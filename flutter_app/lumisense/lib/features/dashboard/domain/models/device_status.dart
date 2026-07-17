import 'package:equatable/equatable.dart';

class DeviceStatus extends Equatable {
  final bool online;
  final String uptime;

  const DeviceStatus({
    required this.online,
    required this.uptime,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      online: json['online'] ?? false,
      uptime: json['uptime'] ?? '00:00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'online': online,
      'uptime': uptime,
    };
  }

  @override
  List<Object?> get props => [online, uptime];
}