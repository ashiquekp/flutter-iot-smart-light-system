import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool autoMode;
  final bool notificationsEnabled;
  final int brightness;
  final int threshold;

  const AppSettings({
    this.autoMode = true,
    this.notificationsEnabled = true,
    this.brightness = 128,
    this.threshold = 500,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      autoMode: json['autoMode'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      brightness: json['brightness'] ?? 128,
      threshold: json['threshold'] ?? 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoMode': autoMode,
      'notificationsEnabled': notificationsEnabled,
      'brightness': brightness,
      'threshold': threshold,
    };
  }

  @override
  List<Object?> get props => [autoMode, notificationsEnabled, brightness, threshold];
}