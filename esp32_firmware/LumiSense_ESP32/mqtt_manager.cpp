#include "mqtt_manager.h"
#include "config.h"

MQTTManager::MQTTManager() : _connected(false), _lastReconnectAttempt(0) {}

void MQTTManager::init(WiFiClient& client) {
    _client.setClient(client);
    _client.setKeepAlive(30);
}

void MQTTManager::connect(const char* broker, int port, const char* clientId) {
    _client.setServer(broker, port);
    
    Serial.print("Connecting to MQTT broker... ");
    if (_client.connect(clientId)) {
        _connected = true;
        Serial.println("✓ Connected!");
    } else {
        _connected = false;
        Serial.print("✗ Failed, rc=");
        Serial.println(_client.state());
    }
}

bool MQTTManager::isConnected() {
    if (_client.connected()) {
        _connected = true;
    } else {
        _connected = false;
        if (_client.state() != MQTT_CONNECTED) {
            // Try to reconnect if disconnected
            unsigned long currentMillis = millis();
            if (currentMillis - _lastReconnectAttempt > RECONNECT_INTERVAL) {
                _lastReconnectAttempt = currentMillis;
                if (_client.connect(MQTT_CLIENT_ID)) {
                    _connected = true;
                    Serial.println("MQTT reconnected!");
                }
            }
        }
    }
    return _connected;
}

void MQTTManager::disconnect() {
    _client.disconnect();
    _connected = false;
}

void MQTTManager::loop() {
    if (_connected) {
        _client.loop();
    }
}

bool MQTTManager::publish(const char* topic, const char* payload, bool retained) {
    if (_connected) {
        return _client.publish(topic, payload, retained);
    }
    return false;
}

bool MQTTManager::publish(const char* topic, const String& payload, bool retained) {
    if (_connected) {
        return _client.publish(topic, payload.c_str(), retained);
    }
    return false;
}

void MQTTManager::subscribe(const char* topic) {
    if (_connected) {
        _client.subscribe(topic);
        Serial.print("Subscribed to: ");
        Serial.println(topic);
    }
}

void MQTTManager::setCallback(MQTT_CALLBACK_SIGNATURE) {
    _client.setCallback(callback);
}