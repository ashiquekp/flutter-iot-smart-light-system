import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';

final mqttConnectionProvider = StateNotifierProvider<MqttConnectionNotifier, AsyncValue<bool>>((ref) {
  final mqttService = ref.watch(mqttServiceProvider);
  return MqttConnectionNotifier(mqttService);
});

class MqttConnectionNotifier extends StateNotifier<AsyncValue<bool>> {
  final MqttService _mqttService;

  MqttConnectionNotifier(this._mqttService) : super(const AsyncValue.loading()) {
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    try {
      await _mqttService.connect();
      state = const AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> reconnect() async {
    state = const AsyncValue.loading();
    try {
      await _mqttService.connect();
      state = const AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void disconnect() {
    _mqttService.disconnect();
    state = const AsyncValue.data(false);
  }

  @override
  void dispose() {
    _mqttService.dispose();
    super.dispose();
  }
}