import 'package:equatable/equatable.dart';

class MqttMessage extends Equatable {
  final String topic;
  final String payload;
  final DateTime timestamp;

  const MqttMessage({
    required this.topic,
    required this.payload,
    required this.timestamp,
  });

  factory MqttMessage.fromJson(Map<String, dynamic> json) {
    return MqttMessage(
      topic: json['topic'] ?? '',
      payload: json['payload'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get isLdrValue => topic.endsWith('/ldr');
  bool get isStatus => topic.endsWith('/status');
  bool get isMode => topic.endsWith('/mode');
  bool get isBrightness => topic.endsWith('/brightness');

  int get ldrValue {
    if (isLdrValue) {
      return int.tryParse(payload) ?? 0;
    }
    return 0;
  }

  bool get isAutoMode {
    if (isMode) {
      return payload.toLowerCase() == 'auto';
    }
    return false;
  }

  int get brightness {
    if (isBrightness) {
      return int.tryParse(payload) ?? 0;
    }
    return 0;
  }

  @override
  List<Object?> get props => [topic, payload, timestamp];
}