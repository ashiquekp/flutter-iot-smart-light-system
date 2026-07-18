#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <Arduino.h>
#include <WiFi.h>

class WiFiManager {
public:
    WiFiManager();
    void connect(const char* ssid, const char* password);
    bool isConnected();
    void disconnect();
    bool reconnect();
    String getLocalIP();
    int getRSSI();
    String getMacAddress();

private:
    bool _connected;
    unsigned long _lastReconnectAttempt;
    static const unsigned long RECONNECT_INTERVAL = 5000;
};

#endif