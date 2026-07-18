#ifndef SENSOR_MANAGER_H
#define SENSOR_MANAGER_H

#include <Arduino.h>

class SensorManager {
public:
    SensorManager(int pin);
    void init();
    int readLDR();
    bool isDark(int threshold);
    int getAverageReading(int samples = 10);
    int getFilteredReading();

private:
    int _pin;
    int _lastReading;
    unsigned long _lastReadTime;
    static const int FILTER_SAMPLES = 10;
    int _readings[10];
    int _readIndex;
    float _alpha; // Exponential moving average factor
};

#endif