import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/dashboard/domain/models/device_status.dart';
import 'package:lumisense/features/dashboard/domain/models/light_data.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';
import 'dart:convert';

// Provider for LDR value
final ldrValueProvider = StateProvider<int>((ref) {
  return 0;
});

// Provider for device status
final deviceStatusProvider = StateProvider<DeviceStatus>((ref) {
  return const DeviceStatus(
    online: true,
    uptime: '00:00:00',
  );
});

// Provider for light data
final lightDataProvider = StateProvider<LightData>((ref) {
  return const LightData(
    ldrValue: 0,
    brightness: 128,
    isAutoMode: true,
    isLedOn: false,
  );
});

// Provider to listen to MQTT messages
final mqttMessageListenerProvider = Provider<void>((ref) {
  final mqttService = ref.watch(mqttServiceProvider);
  
  mqttService.messages.listen((message) {
    final topic = message['topic'] as String;
    final payload = message['payload'] as String;
    
    // print('📨 MQTT Message: $topic -> $payload');
    
    if (topic.endsWith('/ldr')) {
      try {
        final ldrValue = int.parse(payload);
        ref.read(ldrValueProvider.notifier).state = ldrValue;
        // print('🔄 Updated LDR: $ldrValue');
      } catch (e) {
        // print('❌ Error parsing LDR value: $e');
      }
    } else if (topic.endsWith('/status')) {
      try {
        final json = jsonDecode(payload);
        if (json is Map<String, dynamic>) {
          final status = DeviceStatus.fromJson(json);
          ref.read(deviceStatusProvider.notifier).state = status;
          // print('🔄 Updated Status: uptime=${status.uptime}');
        }
      } catch (e) {
        // print('❌ Error parsing status: $e');
      }
    } else if (topic.endsWith('/brightness')) {
      try {
        final brightness = int.parse(payload);
        final currentData = ref.read(lightDataProvider);
        ref.read(lightDataProvider.notifier).state = LightData(
          ldrValue: currentData.ldrValue,
          brightness: brightness,
          isAutoMode: currentData.isAutoMode,
          isLedOn: currentData.isLedOn,
        );
        // print('🔄 Updated Brightness: $brightness');
      } catch (e) {
        // print('❌ Error parsing brightness: $e');
      }
    } else if (topic.endsWith('/mode')) {
      try {
        final isAuto = payload.toLowerCase() == 'auto';
        final currentData = ref.read(lightDataProvider);
        ref.read(lightDataProvider.notifier).state = LightData(
          ldrValue: currentData.ldrValue,
          brightness: currentData.brightness,
          isAutoMode: isAuto,
          isLedOn: currentData.isLedOn,
        );
        // print('🔄 Updated Mode: ${isAuto ? "Auto" : "Manual"}');
      } catch (e) {
        // print('❌ Error parsing mode: $e');
      }
    }
  });
  
  // Return a dummy value - this provider doesn't need to return anything
  // ignore: avoid_returning_null_for_void
  return null;
});

// Also listen in the MQTT connection provider
final dashboardInitProvider = Provider<void>((ref) {
  // This ensures the message listener is initialized
  ref.watch(mqttMessageListenerProvider);
  // ignore: avoid_returning_null_for_void
  return null;
});