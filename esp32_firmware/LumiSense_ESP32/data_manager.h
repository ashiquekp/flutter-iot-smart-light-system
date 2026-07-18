#ifndef DATA_MANAGER_H
#define DATA_MANAGER_H

#include <Arduino.h>

struct LightData {
    int ldrValue;
    int brightness;
    bool isAutoMode;
    bool isLedOn;
    unsigned long timestamp;
};

class DataManager {
public:
    DataManager();
    void updateLightData(int ldr, int brightness, bool autoMode, bool ledOn);
    LightData getCurrentData();
    String toJSON();
    void reset();

private:
    LightData _currentData;
};

#endif