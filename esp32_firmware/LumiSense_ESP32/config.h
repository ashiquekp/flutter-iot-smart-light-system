#ifndef CONFIG_H
#define CONFIG_H

#include <Arduino.h>

// ============================================
// WiFi Configuration
// ============================================
#define WIFI_SSID "your_wifi_ssid"           // Replace with your WiFi SSID
#define WIFI_PASSWORD "your_wifi_password"    // Replace with your WiFi password

// ============================================
// MQTT Configuration
// ============================================
#define MQTT_BROKER "broker.hivemq.com"    // HiveMQ public broker
#define MQTT_PORT 1883
#define MQTT_CLIENT_ID "esp32_lumisense_001"

// ============================================
// MQTT Topics
// ============================================
// Publish Topics (ESP32 -> Flutter)
#define MQTT_TOPIC_LDR "lumisense/esp32_001/telemetry/ldr"
#define MQTT_TOPIC_STATUS "lumisense/esp32_001/status"
#define MQTT_TOPIC_MODE "lumisense/esp32_001/mode"
#define MQTT_TOPIC_BRIGHTNESS "lumisense/esp32_001/brightness"
#define MQTT_TOPIC_LED_STATUS "lumisense/esp32_001/led_status"

// Subscribe Topics (Flutter -> ESP32)
#define MQTT_TOPIC_COMMAND_MODE "lumisense/esp32_001/command/mode"
#define MQTT_TOPIC_COMMAND_BRIGHTNESS "lumisense/esp32_001/command/brightness"
#define MQTT_TOPIC_COMMAND_THRESHOLD "lumisense/esp32_001/command/threshold"
#define MQTT_TOPIC_COMMAND_LED "lumisense/esp32_001/command/led"
#define MQTT_TOPIC_COMMAND_LED_COLOR "lumisense/esp32_001/command/led_color"

// ============================================
// Pin Definitions - XIAO ESP32-C3
// ============================================
// LED Pins (Individual Control)
#define LED_PIN_RED D0      // GPIO2 - Red LED
#define LED_PIN_GREEN D1    // GPIO3 - Green LED
#define LED_PIN_YELLOW D2   // GPIO4 - Yellow LED
#define LED_PIN_WHITE D5    // GPIO5 - White LED
#define LED_PIN_BLUE D6     // GPIO6 - Blue LED
#define LED_PIN_ORANGE D7   // GPIO7 - Orange LED

// LDR Sensor Pin
#define LDR_PIN D8          // GPIO8 - Analog Input

// LED Colors Enum
enum LedColor {
  LED_RED,
  LED_GREEN,
  LED_YELLOW,
  LED_WHITE,
  LED_BLUE,
  LED_ORANGE,
  LED_ALL
};

// ============================================
// Default Values
// ============================================
#define DEFAULT_THRESHOLD 500               // Default LDR threshold
#define DEFAULT_BRIGHTNESS 128              // Default LED brightness (0-255)
#define DEFAULT_AUTO_MODE true              // Default mode

// ============================================
// Timing Configuration
// ============================================
#define SENSOR_READ_INTERVAL 1000           // Sensor read interval (ms)
#define MQTT_PUBLISH_INTERVAL 2000          // MQTT publish interval (ms)

// ============================================
// LED Configuration
// ============================================
#define MAX_BRIGHTNESS 255                  // Maximum PWM brightness
#define LED_COUNT 6                         // Number of LEDs

#endif