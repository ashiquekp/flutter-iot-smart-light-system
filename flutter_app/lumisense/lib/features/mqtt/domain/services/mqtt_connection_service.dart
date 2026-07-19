import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/data/repositories/mqtt_repository.dart';
import 'package:lumisense/features/mqtt/domain/models/mqtt_message.dart';

final mqttConnectionServiceProvider = Provider<MqttConnectionService>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return MqttConnectionService(repository);
});

class MqttConnectionService {
  final MqttRepository _repository;

  MqttConnectionService(this._repository);

  Future<void> connect() async {
    await _repository.connect();
  }

  Future<void> disconnect() async {
    await _repository.disconnect();
  }

  bool isConnected() {
    return _repository.isConnected();
  }

  Stream<MqttMessage> getMessages() {
    return _repository.getMessages();
  }

  Future<void> publish(String topic, String payload, {bool retained = false}) async {
    await _repository.publishMessage(topic, payload, retained: retained);
  }

  Future<void> subscribe(String topic) async {
    await _repository.subscribe(topic);
  }

  Future<void> unsubscribe(String topic) async {
    await _repository.unsubscribe(topic);
  }

  void dispose() {
    _repository.dispose();
  }
}