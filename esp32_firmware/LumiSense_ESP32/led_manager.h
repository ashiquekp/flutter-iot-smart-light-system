#ifndef LED_MANAGER_H
#define LED_MANAGER_H

#include <Arduino.h>
#include "config.h"

struct LedConfig {
  int pin;
  String name;
  int brightness;
  bool isOn;
};

class LEDManager {
public:
  LEDManager();
  void init();
  
  // Individual LED control
  void setColor(LedColor color, int brightness);
  void turnOn(LedColor color);
  void turnOff(LedColor color);
  void toggle(LedColor color);
  
  // All LEDs control
  void turnAllOn();
  void turnAllOff();
  void setAllBrightness(int brightness);
  
  // Status queries
  bool isOn(LedColor color);
  int getBrightness(LedColor color);
  String getStatus();
  
  // Auto mode
  void autoAdjust(int ldrValue, int threshold, int maxBrightness = 255);
  void setAutoMode(bool autoMode);
  bool isAutoMode();
  
  // Get all LEDs status as JSON
  String getLEDStatusJSON();

private:
  LedConfig _leds[6];
  bool _autoMode;
  int _threshold;
  int _pwmChannel[6];
  
  int _getPinForColor(LedColor color);
  int _getIndexForColor(LedColor color);
  int _getChannelForColor(LedColor color);
};

#endif