#ifndef MQTT_MANAGER_H
#define MQTT_MANAGER_H

#include <Arduino.h>
#include <PubSubClient.h>
#include <WiFiClient.h>

class MQTTManager {
public:
    MQTTManager();
    void init(WiFiClient& client);
    void connect(const char* broker, int port, const char* clientId);
    bool isConnected();
    void disconnect();
    void loop();
    bool publish(const char* topic, const char* payload, bool retained = false);
    bool publish(const char* topic, const String& payload, bool retained = false);
    void subscribe(const char* topic);
    void setCallback(MQTT_CALLBACK_SIGNATURE);

private:
    PubSubClient _client;
    bool _connected;
    unsigned long _lastReconnectAttempt;
    static const unsigned long RECONNECT_INTERVAL = 5000;
};

#endif