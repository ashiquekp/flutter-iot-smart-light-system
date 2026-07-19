#include "led_manager.h"

LEDManager::LEDManager() : _autoMode(true), _threshold(500) {
  // Initialize LED configurations
  _leds[0] = {LED_PIN_RED, "Red", 0, false};
  _leds[1] = {LED_PIN_GREEN, "Green", 0, false};
  _leds[2] = {LED_PIN_YELLOW, "Yellow", 0, false};
  _leds[3] = {LED_PIN_WHITE, "White", 0, false};
  _leds[4] = {LED_PIN_BLUE, "Blue", 0, false};
  _leds[5] = {LED_PIN_ORANGE, "Orange", 0, false};
  
  // Initialize PWM channels.
  _pwmChannel[0] = 0;
  _pwmChannel[1] = 1;
  _pwmChannel[2] = 2;
  _pwmChannel[3] = 3;
  _pwmChannel[4] = 4;
  _pwmChannel[5] = 5;
}

void LEDManager::init() {
  for (int i = 0; i < 6; i++) {
    pinMode(_leds[i].pin, OUTPUT);
    // Setup PWM for each LED - ESP32-C3 uses ledcAttach.
    ledcAttach(_leds[i].pin, 5000, 8);  // 5 kHz, 8-bit resolution.
    ledcWrite(_leds[i].pin, 0);
    _leds[i].isOn = false;
    _leds[i].brightness = 0;
  }
}

int LEDManager::_getPinForColor(LedColor color) {
  if (color == LED_ALL) return -1;
  return _leds[_getIndexForColor(color)].pin;
}

int LEDManager::_getIndexForColor(LedColor color) {
  switch(color) {
    case LED_RED: return 0;
    case LED_GREEN: return 1;
    case LED_YELLOW: return 2;
    case LED_WHITE: return 3;
    case LED_BLUE: return 4;
    case LED_ORANGE: return 5;
    default: return -1;
  }
}

int LEDManager::_getChannelForColor(LedColor color) {
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    return _pwmChannel[index];
  }
  return -1;
}

void LEDManager::setColor(LedColor color, int brightness) {
  brightness = constrain(brightness, 0, 255);
  
  if (color == LED_ALL) {
    setAllBrightness(brightness);
    return;
  }
  
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    _leds[index].brightness = brightness;
    if (_leds[index].isOn) {
      ledcWrite(_leds[index].pin, brightness);
    }
  }
}

void LEDManager::turnOn(LedColor color) {
  if (color == LED_ALL) {
    turnAllOn();
    return;
  }
  
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    _leds[index].isOn = true;
    ledcWrite(_leds[index].pin, _leds[index].brightness);
  }
}

void LEDManager::turnOff(LedColor color) {
  if (color == LED_ALL) {
    turnAllOff();
    return;
  }
   
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    _leds[index].isOn = false;
    ledcWrite(_leds[index].pin, 0);
  }
}

void LEDManager::toggle(LedColor color) {
  if (isOn(color)) {
    turnOff(color);
  } else {
    turnOn(color);
  }
}

void LEDManager::turnAllOn() {
  for (int i = 0; i < 6; i++) {
    _leds[i].isOn = true;
    ledcWrite(_leds[i].pin, _leds[i].brightness);
  }
}
 
void LEDManager::turnAllOff() {
  for (int i = 0; i < 6; i++) {
    _leds[i].isOn = false;
    ledcWrite(_leds[i].pin, 0);
  }
}

void LEDManager::setAllBrightness(int brightness) {
  brightness = constrain(brightness, 0, 255);
  for (int i = 0; i < 6; i++) {
    _leds[i].brightness = brightness;
    if (_leds[i].isOn) {
      ledcWrite(_leds[i].pin, brightness);
    }
  }
}
 
bool LEDManager::isOn(LedColor color) {
  if (color == LED_ALL) {
    // Return true if any LED is on
    for (int i = 0; i < 6; i++) {
      if (_leds[i].isOn) return true;
    }
    return false;
  }
  
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    return _leds[index].isOn;
  }
  return false;
}

int LEDManager::getBrightness(LedColor color) {
  if (color == LED_ALL) {
    // Return average brightness.
    int sum = 0;
    for (int i = 0; i < 6; i++) {
      sum += _leds[i].brightness;
    }
    return sum / 6;
  }
  
  int index = _getIndexForColor(color);
  if (index >= 0 && index < 6) {
    return _leds[index].brightness;
  }
  return 0;
}

void LEDManager::autoAdjust(int ldrValue, int threshold, int maxBrightness) {
  _threshold = threshold;
  _autoMode = true;
  
  int brightness;
  if (ldrValue < threshold) {
    // Dark room: increase brightness
    brightness = map(ldrValue, 0, threshold, maxBrightness, 0);
    brightness = constrain(brightness, 0, maxBrightness);
  } else {
    // Bright room: decrease brightness
    brightness = 0;
  }
  
  setAllBrightness(brightness);
  
  // If all LEDs are off but brightness > 0, turn them on.
  if (brightness > 0 && !isOn(LED_ALL)) {
    turnAllOn();
  } else if (brightness == 0 && isOn(LED_ALL)) {
    turnAllOff();
  }
}

void LEDManager::setAutoMode(bool autoMode) {
  _autoMode = autoMode;
}

bool LEDManager::isAutoMode() {
  return _autoMode;
}

String LEDManager::getStatus() {
  String status = "";
  for (int i = 0; i < 6; i++) {
    status += _leds[i].name + ":";
    status += _leds[i].isOn ? "ON" : "OFF";
    status += "(" + String(_leds[i].brightness) + ")";
    if (i < 5) status += ",";
  }
  return status;
}

String LEDManager::getLEDStatusJSON() {
  String json = "{";
  for (int i = 0; i < 6; i++) {
    // Fixed: Store color name in a separate String variable.
    String colorName = _leds[i].name;
    colorName.toLowerCase();
    json += "\"" + colorName + "\":{";
    json += "\"on\":" + String(_leds[i].isOn ? "true" : "false") + ",";
    json += "\"brightness\":" + String(_leds[i].brightness);
    json += "}";
    if (i < 5) json += ",";
  }
  json += "}";
  return json;
}