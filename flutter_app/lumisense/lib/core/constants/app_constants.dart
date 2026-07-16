class AppConstants {
  static const String appName = 'LumiSense';
  static const String appVersion = '1.0.0';
  
  // SharedPreferences Keys
  static const String keyThreshold = 'threshold';
  static const String keyMode = 'mode';
  static const String keyBrightness = 'brightness';
  static const String keyAutoBrightness = 'auto_brightness';
  
  // Default Values
  static const int defaultThreshold = 500;
  static const int defaultBrightness = 128;
  static const bool defaultAutoMode = true;
  
  // MQTT
  // static const String mqttBroker = 'test.mosquitto.org';
  static const String mqttBroker = 'broker.hivemq.com';
  static const int mqttPort = 1883;
  static const String mqttClientId = 'flutter_lumisense_';
  
  // History
  static const int maxHistoryItems = 1000;
  static const int historyRetentionDays = 7;
  
  // UI
  static const double cardBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
}