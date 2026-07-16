class MqttTopics {
  static const String baseTopic = 'lumisense';
  static const String deviceId = 'esp32_001';
  
  // Publish Topics (ESP32 -> Flutter)
  static String get ldrValue => '$baseTopic/$deviceId/telemetry/ldr';
  static String get deviceStatus => '$baseTopic/$deviceId/status';
  static String get deviceMode => '$baseTopic/$deviceId/mode';
  static String get deviceBrightness => '$baseTopic/$deviceId/brightness';
  static String get ledStatus => '$baseTopic/$deviceId/led_status';
  
  // Subscribe Topics (Flutter -> ESP32)
  static String get commandMode => '$baseTopic/$deviceId/command/mode';
  static String get commandBrightness => '$baseTopic/$deviceId/command/brightness';
  static String get commandThreshold => '$baseTopic/$deviceId/command/threshold';
  static String get commandLed => '$baseTopic/$deviceId/command/led';
  static String get commandLedColor => '$baseTopic/$deviceId/command/led_color';
  
  // Retained Topics
  static String get retainedStatus => '$baseTopic/$deviceId/status/retained';
  static String get retainedMode => '$baseTopic/$deviceId/mode/retained';
  static String get retainedBrightness => '$baseTopic/$deviceId/brightness/retained';
  static String get retainedThreshold => '$baseTopic/$deviceId/threshold/retained';
}