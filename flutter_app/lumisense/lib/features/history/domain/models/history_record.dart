import 'package:equatable/equatable.dart';

class HistoryRecord extends Equatable {
  final DateTime timestamp;
  final int ldrValue;
  final int brightness;
  final bool isAutoMode;
  final bool isLedOn;

  const HistoryRecord({
    required this.timestamp,
    required this.ldrValue,
    required this.brightness,
    required this.isAutoMode,
    required this.isLedOn,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      timestamp: DateTime.parse(json['timestamp']),
      ldrValue: json['ldrValue'],
      brightness: json['brightness'],
      isAutoMode: json['isAutoMode'],
      isLedOn: json['isLedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'ldrValue': ldrValue,
      'brightness': brightness,
      'isAutoMode': isAutoMode,
      'isLedOn': isLedOn,
    };
  }

  @override
  List<Object?> get props => [timestamp, ldrValue, brightness, isAutoMode, isLedOn];
}