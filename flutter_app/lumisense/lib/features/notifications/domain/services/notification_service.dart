import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/notifications/data/datasources/local_notification_datasource.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final datasource = ref.watch(localNotificationDatasourceProvider);
  return NotificationService(datasource);
});

class NotificationService {
  final LocalNotificationDatasource _datasource;

  NotificationService(this._datasource);

  Future<void> initialize() async {
    await _datasource.initialize();
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _datasource.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> showDarkRoomDetected(int ldrValue) async {
    await _datasource.showNotification(
      title: 'Dark Room Detected',
      body: 'LDR value: $ldrValue - Adjusting brightness',
      payload: 'dark_room',
    );
  }

  Future<void> showBrightRoomDetected(int ldrValue) async {
    await _datasource.showNotification(
      title: 'Bright Room Detected',
      body: 'LDR value: $ldrValue - Reducing brightness',
      payload: 'bright_room',
    );
  }

  Future<void> showModeChanged(String mode) async {
    await _datasource.showNotification(
      title: 'Mode Changed',
      body: 'Switched to $mode mode',
      payload: 'mode_changed',
    );
  }

  Future<void> showConnectionLost() async {
    await _datasource.showNotification(
      title: 'Connection Lost',
      body: 'Disconnected from MQTT broker',
      payload: 'connection_lost',
    );
  }

  Future<void> showConnectionRestored() async {
    await _datasource.showNotification(
      title: 'Connection Restored',
      body: 'Reconnected to MQTT broker',
      payload: 'connection_restored',
    );
  }
}