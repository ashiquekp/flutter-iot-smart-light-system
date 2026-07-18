#include "data_manager.h"

DataManager::DataManager() {
    reset();
}

void DataManager::updateLightData(int ldr, int brightness, bool autoMode, bool ledOn) {
    _currentData.ldrValue = ldr;
    _currentData.brightness = brightness;
    _currentData.isAutoMode = autoMode;
    _currentData.isLedOn = ledOn;
    _currentData.timestamp = millis();
}

LightData DataManager::getCurrentData() {
    return _currentData;
}

String DataManager::toJSON() {
    String json = "{";
    json += "\"ldrValue\":" + String(_currentData.ldrValue) + ",";
    json += "\"brightness\":" + String(_currentData.brightness) + ",";
    json += "\"isAutoMode\":" + String(_currentData.isAutoMode ? "true" : "false") + ",";
    json += "\"isLedOn\":" + String(_currentData.isLedOn ? "true" : "false") + ",";
    json += "\"timestamp\":" + String(_currentData.timestamp);
    json += "}";
    return json;
}

void DataManager::reset() {
    _currentData = {0, 0, true, false, 0};
}