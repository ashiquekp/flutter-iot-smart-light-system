#include "wifi_manager.h"

WiFiManager::WiFiManager() : _connected(false), _lastReconnectAttempt(0) {}

void WiFiManager::connect(const char* ssid, const char* password) {
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);
    
    Serial.print("Connecting to WiFi");
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 20) {
        delay(500);
        Serial.print(".");
        attempts++;
    }
    
    if (WiFi.status() == WL_CONNECTED) {
        _connected = true;
        Serial.println("\n✓ WiFi connected!");
        Serial.print("  IP address: ");
        Serial.println(WiFi.localIP());
        Serial.print("  RSSI: ");
        Serial.println(WiFi.RSSI());
        Serial.print("  MAC: ");
        Serial.println(WiFi.macAddress());
    } else {
        _connected = false;
        Serial.println("\n✗ WiFi connection failed!");
        Serial.println("  Please check SSID and password");
    }
}

bool WiFiManager::isConnected() {
    if (WiFi.status() == WL_CONNECTED) {
        _connected = true;
    } else {
        _connected = false;
    }
    return _connected;
}

void WiFiManager::disconnect() {
    WiFi.disconnect();
    _connected = false;
}

bool WiFiManager::reconnect() {
    if (WiFi.status() != WL_CONNECTED) {
        unsigned long currentMillis = millis();
        if (currentMillis - _lastReconnectAttempt > RECONNECT_INTERVAL) {
            _lastReconnectAttempt = currentMillis;
            Serial.println("Attempting to reconnect to WiFi...");
            WiFi.reconnect();
            return WiFi.status() == WL_CONNECTED;
        }
    }
    return _connected;
}

String WiFiManager::getLocalIP() {
    return WiFi.localIP().toString();
}

int WiFiManager::getRSSI() {
    return WiFi.RSSI();
}

String WiFiManager::getMacAddress() {
    return WiFi.macAddress();
}