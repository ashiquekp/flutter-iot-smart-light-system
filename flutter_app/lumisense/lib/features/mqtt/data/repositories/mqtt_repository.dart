import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/data/datasources/mqtt_datasource.dart';
import 'package:lumisense/features/mqtt/domain/models/mqtt_message.dart';

final mqttRepositoryProvider = Provider<MqttRepository>((ref) {
  final datasource = ref.watch(mqttDatasourceProvider);
  return MqttRepository(datasource);
});

class MqttRepository {
  final MqttDatasource _datasource;

  MqttRepository(this._datasource);

  Future<void> connect() async {
    await _datasource.connect();
  }

  Future<void> disconnect() async {
    await _datasource.disconnect();
  }

  bool isConnected() {
    return _datasource.isConnected();
  }

  Stream<MqttMessage> getMessages() {
    return _datasource.getMessages();
  }

  Future<void> publishMessage(String topic, String payload, {bool retained = false}) async {
    await _datasource.publish(topic, payload, retained: retained);
  }

  Future<void> subscribe(String topic) async {
    await _datasource.subscribe(topic);
  }

  Future<void> unsubscribe(String topic) async {
    await _datasource.unsubscribe(topic);
  }

  void dispose() {
    _datasource.dispose();
  }
}