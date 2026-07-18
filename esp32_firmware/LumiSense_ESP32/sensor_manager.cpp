#include "sensor_manager.h"

SensorManager::SensorManager(int pin) 
    : _pin(pin), _lastReading(0), _lastReadTime(0), _readIndex(0), _alpha(0.1) {
    for (int i = 0; i < FILTER_SAMPLES; i++) {
        _readings[i] = 0;
    }
}

void SensorManager::init() {
    pinMode(_pin, INPUT);
    // Read initial value
    _lastReading = analogRead(_pin);
}

int SensorManager::readLDR() {
    int reading = analogRead(_pin);
    
    // Simple moving average filter
    _readings[_readIndex] = reading;
    _readIndex = (_readIndex + 1) % FILTER_SAMPLES;
    
    long sum = 0;
    for (int i = 0; i < FILTER_SAMPLES; i++) {
        sum += _readings[i];
    }
    
    _lastReading = sum / FILTER_SAMPLES;
    _lastReadTime = millis();
    
    return _lastReading;
}

bool SensorManager::isDark(int threshold) {
    return _lastReading < threshold;
}

int SensorManager::getAverageReading(int samples) {
    if (samples <= 0) return _lastReading;
    if (samples > 20) samples = 20;
    
    long sum = 0;
    for (int i = 0; i < samples; i++) {
        sum += analogRead(_pin);
        delay(10);
    }
    return sum / samples;
}

int SensorManager::getFilteredReading() {
    // Exponential moving average
    int rawReading = analogRead(_pin);
    _lastReading = (_alpha * rawReading) + ((1 - _alpha) * _lastReading);
    return _lastReading;
}