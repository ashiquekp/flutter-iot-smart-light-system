/**
 * LumiSense - Smart Light Automation System
 * ESP32-C3 Firmware for Arduino IDE
 * 
 * This firmware reads an LM393 LDR sensor and controls 6 individual LEDs
 * based on ambient light levels. Communication with the Flutter app
 * is handled via MQTT.
 */

#include <Arduino.h>
#include "config.h"
#include "wifi_manager.h"
#include "mqtt_manager.h"
#include "sensor_manager.h"
#include "led_manager.h"
#include "data_manager.h"

// Global instances
WiFiManager wifiManager;
MQTTManager mqttManager;
SensorManager sensorManager(LDR_PIN);
LEDManager ledManager;
DataManager dataManager;

// State variables
bool autoMode = DEFAULT_AUTO_MODE;
int threshold = DEFAULT_THRESHOLD;
unsigned long lastSensorRead = 0;
unsigned long lastMQTTPublish = 0;
unsigned long lastUptimeUpdate = 0;
unsigned long startTime = 0;
bool wifiConnected = false;
bool mqttConnected = false;
int lastPublishedLdr = -1;
int lastPublishedBrightness = -1;
 
// Function declarations
void publishTelemetry();
void handleMQTTMessage(char* topic, uint8_t* payload, unsigned int length);
void processCommand(String topic, String payload);
void updateDeviceStatus();
void publishLEDStatus();

// WiFi client for MQTT.
WiFiClient espClient;

void setup() {
    Serial.begin(115200);
    delay(1000);  // Wait for serial to initialize.
    
    Serial.println("\n╔═══════════════════════════════════════╗");
    Serial.println("║      LumiSense ESP32-C3 v1.0.0      ║");
    Serial.println("║    Smart Light Automation System     ║");
    Serial.println("║    6x LED Colors + LDR Sensor       ║");
    Serial.println("╚═══════════════════════════════════════╝");
    Serial.println("Initializing hardware...");
    
    // Initialize components
    sensorManager.init();
    ledManager.init();
    dataManager.updateLightData(0, 0, autoMode, false);
    
    // Connect to WiFi.
    Serial.print("Connecting to WiFi ");
    wifiManager.connect(WIFI_SSID, WIFI_PASSWORD);
    
    if (wifiManager.isConnected()) {
        Serial.println("✓ WiFi connected!");
        Serial.print("  IP Address: ");
        Serial.println(wifiManager.getLocalIP());
    } else {
        Serial.println("✗ WiFi connection failed!");
    }
    
    // Initialize MQTT
    mqttManager.init(espClient);
    mqttManager.setCallback(handleMQTTMessage);
    
    // Try to connect to MQTT broker.
    if (wifiManager.isConnected()) {
        Serial.print("Connecting to MQTT broker... ");
        mqttManager.connect(MQTT_BROKER, MQTT_PORT, MQTT_CLIENT_ID);
        
        if (mqttManager.isConnected()) {
            mqttConnected = true;
            Serial.println("✓ Connected!");
            
            // Subscribe to command topics.
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_MODE);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_BRIGHTNESS);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_THRESHOLD);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_LED);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_LED_COLOR);
            
            // Publish initial status.
            mqttManager.publish(MQTT_TOPIC_STATUS, "{\"status\":\"online\",\"message\":\"ESP32 initialized\"}");
        } else {
            Serial.println("✗ Failed to connect!");
        }
    }
    
    startTime = millis();
    Serial.println("✓ Setup complete!");
    Serial.println("=========================================");
}

void loop() {
    // Maintain WiFi connection
    if (!wifiManager.isConnected()) {
        if (wifiManager.reconnect()) {
            Serial.println("WiFi reconnected!");
            wifiConnected = true;
        } else {
            wifiConnected = false;
            Serial.println("WiFi connection lost!");
        }
    } else {
        wifiConnected = true;
    }
    
    // Maintain MQTT connection
    if (wifiConnected && !mqttManager.isConnected()) {
        Serial.print("Reconnecting to MQTT... ");
        mqttManager.connect(MQTT_BROKER, MQTT_PORT, MQTT_CLIENT_ID);
        if (mqttManager.isConnected()) {
            mqttConnected = true;
            Serial.println("✓ Reconnected!");
            
            // Resubscribe to topics
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_MODE);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_BRIGHTNESS);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_THRESHOLD);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_LED);
            mqttManager.subscribe(MQTT_TOPIC_COMMAND_LED_COLOR);
            
            // Publish reconnection status
            mqttManager.publish(MQTT_TOPIC_STATUS, "{\"status\":\"reconnected\",\"message\":\"MQTT connection restored\"}");
        } else {
            mqttConnected = false;
            Serial.println("✗ Reconnect failed!");
        }
    }
    
    // Process MQTT messages
    if (mqttConnected) {
        mqttManager.loop();
    }
    
    unsigned long currentMillis = millis();
    
    // Read sensor and update LED - More frequent reading
    if (currentMillis - lastSensorRead >= SENSOR_READ_INTERVAL) {
        lastSensorRead = currentMillis;
        
        int ldrValue = sensorManager.readLDR();
        int filteredValue = sensorManager.getAverageReading(5);
        
        Serial.print("🔦 LDR Raw: ");
        Serial.print(ldrValue);
        Serial.print(" | Filtered: ");
        Serial.println(filteredValue);
        
        if (autoMode) {
            ledManager.autoAdjust(filteredValue, threshold, 255);
        }
        
        // Update data manager
        dataManager.updateLightData(
            filteredValue,
            ledManager.getBrightness(LED_ALL),
            autoMode,
            ledManager.isOn(LED_ALL)
        );
        
        // Check for dark/bright room conditions
        if (filteredValue < threshold && filteredValue < 100) {
            if (mqttConnected) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"event\":\"dark_room\",\"ldr_value\":" + String(filteredValue) + "}");
            }
        } else if (filteredValue > threshold + 200) {
            if (mqttConnected) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"event\":\"bright_room\",\"ldr_value\":" + String(filteredValue) + "}");
            }
        }
        
        // Publish telemetry - always publish on change.
        if (mqttConnected) {
            publishTelemetry();
            publishLEDStatus();
        }
    }
    
    // Update uptime status every 5 seconds (more frequent)
    if (mqttConnected && currentMillis - lastUptimeUpdate >= 5000) {
        lastUptimeUpdate = currentMillis;
        updateDeviceStatus();
    }
    
    // Small delay to prevent watchdog issues.
    delay(10);
}

void publishTelemetry() {
    LightData data = dataManager.getCurrentData();
    char buffer[32];
    
    // Always publish even if values haven't changed (for testing).
    snprintf(buffer, sizeof(buffer), "%d", data.ldrValue);
    mqttManager.publish(MQTT_TOPIC_LDR, buffer);
    Serial.print("📤 Published LDR: ");
    Serial.println(buffer);
    
    // Publish brightness (average)
    snprintf(buffer, sizeof(buffer), "%d", data.brightness);
    mqttManager.publish(MQTT_TOPIC_BRIGHTNESS, buffer);
    Serial.print("📤 Published Brightness: ");
    Serial.println(buffer);
    
    // Publish mode
    mqttManager.publish(MQTT_TOPIC_MODE, data.isAutoMode ? "auto" : "manual");
    
    // Print to serial for debugging
    Serial.print("📊 LDR: ");
    Serial.print(data.ldrValue);
    Serial.print(" | Brightness: ");
    Serial.print(data.brightness);
    Serial.print(" | Mode: ");
    Serial.print(data.isAutoMode ? "Auto" : "Manual");
    Serial.print(" | LED: ");
    Serial.println(data.isLedOn ? "ON" : "OFF");
}
 
void publishLEDStatus() {
    String ledStatus = ledManager.getLEDStatusJSON();
    mqttManager.publish(MQTT_TOPIC_LED_STATUS, ledStatus.c_str());
}
 
void handleMQTTMessage(char* topic, uint8_t* payload, unsigned int length) {
    String topicStr = String(topic);
    String payloadStr = "";
    
    for (unsigned int i = 0; i < length; i++) {
        payloadStr += (char)payload[i];
    }
    
    Serial.print("📨 MQTT Message [");
    Serial.print(topicStr);
    Serial.print("]: ");
    Serial.println(payloadStr);
    
    processCommand(topicStr, payloadStr);
}
 
void processCommand(String topic, String payload) {
    if (topic == MQTT_TOPIC_COMMAND_MODE) {
        if (payload == "auto") {
            autoMode = true;
            ledManager.setAutoMode(true);
            Serial.println("🔄 Switched to AUTO mode");
            if (mqttManager.isConnected()) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"mode_changed\":\"auto\"}");
            }
        } else if (payload == "manual") {
            autoMode = false;
            ledManager.setAutoMode(false);
            Serial.println("🔄 Switched to MANUAL mode");
            if (mqttManager.isConnected()) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"mode_changed\":\"manual\"}");
            }
        }
        dataManager.updateLightData(
            dataManager.getCurrentData().ldrValue,
            ledManager.getBrightness(LED_ALL),
            autoMode,
            ledManager.isOn(LED_ALL)
        );
    } 
    else if (topic == MQTT_TOPIC_COMMAND_BRIGHTNESS) {
        int brightness = payload.toInt();
        brightness = constrain(brightness, 0, 255);
        ledManager.setAllBrightness(brightness);
        Serial.print("💡 All LEDs brightness set to: ");
        Serial.println(brightness);
        
        dataManager.updateLightData(
            dataManager.getCurrentData().ldrValue,
            brightness,
            autoMode,
            ledManager.isOn(LED_ALL)
        );
    }
    else if (topic == MQTT_TOPIC_COMMAND_LED_COLOR) {
        int commaIndex = payload.indexOf(',');
        if (commaIndex > 0) {
            String colorStr = payload.substring(0, commaIndex);
            String brightnessStr = payload.substring(commaIndex + 1);
            int brightness = brightnessStr.toInt();
            brightness = constrain(brightness, 0, 255);
            
            LedColor color;
            if (colorStr == "red") color = LED_RED;
            else if (colorStr == "green") color = LED_GREEN;
            else if (colorStr == "yellow") color = LED_YELLOW;
            else if (colorStr == "white") color = LED_WHITE;
            else if (colorStr == "blue") color = LED_BLUE;
            else if (colorStr == "orange") color = LED_ORANGE;
            else return;
            
            ledManager.setColor(color, brightness);
            ledManager.turnOn(color);
            Serial.print("💡 " + colorStr + " LED brightness set to: ");
            Serial.println(brightness);
            publishLEDStatus();
        }
    }
    else if (topic == MQTT_TOPIC_COMMAND_LED) {
        if (payload == "on") {
            ledManager.turnAllOn();
            Serial.println("💡 All LEDs turned ON");
            if (mqttManager.isConnected()) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"led\":\"all_on\"}");
            }
        } else if (payload == "off") {
            ledManager.turnAllOff();
            Serial.println("💡 All LEDs turned OFF");
            if (mqttManager.isConnected()) {
                mqttManager.publish(MQTT_TOPIC_STATUS, "{\"led\":\"all_off\"}");
            }
        }
        dataManager.updateLightData(
            dataManager.getCurrentData().ldrValue,
            ledManager.getBrightness(LED_ALL),
            autoMode,
            ledManager.isOn(LED_ALL)
        );
        publishLEDStatus();
    }
    else if (topic == MQTT_TOPIC_COMMAND_THRESHOLD) {
        threshold = payload.toInt();
        threshold = constrain(threshold, 0, 1023);
        Serial.print("🎯 Threshold set to: ");
        Serial.println(threshold);
    }
}
 
void updateDeviceStatus() {
    unsigned long uptime = (millis() - startTime) / 1000;
    unsigned long hours = uptime / 3600;
    unsigned long minutes = (uptime / 60) % 60;
    unsigned long seconds = uptime % 60;
    
    char uptimeStr[20];
    snprintf(uptimeStr, sizeof(uptimeStr), "%02lu:%02lu:%02lu", hours, minutes, seconds);
    
    String statusJson = "{";
    statusJson += "\"online\":true,";
    statusJson += "\"uptime\":\"" + String(uptimeStr) + "\",";
    statusJson += "\"ip\":\"" + wifiManager.getLocalIP() + "\",";
    statusJson += "\"rssi\":" + String(wifiManager.getRSSI()) + ",";
    statusJson += "\"mode\":\"" + String(autoMode ? "auto" : "manual") + "\",";
    statusJson += "\"ldr\":" + String(dataManager.getCurrentData().ldrValue) + ",";
    statusJson += "\"brightness\":" + String(ledManager.getBrightness(LED_ALL));
    statusJson += "}";
    
    mqttManager.publish(MQTT_TOPIC_STATUS, statusJson.c_str(), true);
    Serial.print("📡 Status updated: ");
    Serial.println(statusJson);
}