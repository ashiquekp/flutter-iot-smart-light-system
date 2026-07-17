import 'package:equatable/equatable.dart';

class LightData extends Equatable {
  final int ldrValue;
  final int brightness;
  final bool isAutoMode;
  final bool isLedOn;

  const LightData({
    required this.ldrValue,
    required this.brightness,
    required this.isAutoMode,
    required this.isLedOn,
  });

  factory LightData.fromJson(Map<String, dynamic> json) {
    return LightData(
      ldrValue: json['ldrValue'] ?? 0,
      brightness: json['brightness'] ?? 128,
      isAutoMode: json['isAutoMode'] ?? true,
      isLedOn: json['isLedOn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ldrValue': ldrValue,
      'brightness': brightness,
      'isAutoMode': isAutoMode,
      'isLedOn': isLedOn,
    };
  }

  @override
  List<Object?> get props => [ldrValue, brightness, isAutoMode, isLedOn];
}