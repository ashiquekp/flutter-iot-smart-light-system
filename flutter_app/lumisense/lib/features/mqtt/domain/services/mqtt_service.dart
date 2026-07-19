import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:lumisense/core/constants/app_constants.dart';
import 'package:lumisense/core/constants/mqtt_topics.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final mqttServiceProvider = Provider<MqttService>((ref) {
  return MqttService();
});

class MqttService {
  MqttServerClient? _client;  // Changed from MqttClient to MqttServerClient
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Use MqttServerClient instead of MqttClient
      _client = MqttServerClient(
        AppConstants.mqttBroker,
        '${AppConstants.mqttClientId}${DateTime.now().millisecondsSinceEpoch}',
      );

      _client!.logging(on: true);
      _client!.keepAlivePeriod = 20;
      _client!.autoReconnect = true;
      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;
      _client!.onSubscribed = _onSubscribed;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier(_client!.clientIdentifier)
          .withWillTopic('${MqttTopics.baseTopic}/${MqttTopics.deviceId}/status')
          .withWillMessage('offline')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
      _client!.connectionMessage = connMessage;

      await _client!.connect();

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;
        _subscribeToTopics();
      } else {
        throw Exception('Failed to connect to MQTT broker');
      }

      _client!.updates!.listen(_handleIncomingMessage);
    } catch (e) {
      throw Exception('MQTT connection error: $e');
    }
  }

  void _subscribeToTopics() {
    _client!.subscribe(MqttTopics.ldrValue, MqttQos.atLeastOnce);
    _client!.subscribe(MqttTopics.deviceStatus, MqttQos.atLeastOnce);
    _client!.subscribe(MqttTopics.deviceMode, MqttQos.atLeastOnce);
    _client!.subscribe(MqttTopics.deviceBrightness, MqttQos.atLeastOnce);
  }

  void _handleIncomingMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final message in messages) {
      final topic = message.topic;
      if (message.payload is MqttPublishMessage) {
        final payload = (message.payload as MqttPublishMessage).payload.message;
        final messageMap = {
          'topic': topic,
          'payload': String.fromCharCodes(payload),
        };
        _messageController.add(messageMap);
      }
    }
  }

  void _onConnected() {
    _isConnected = true;
    // print('MQTT Connected');
  }

  void _onDisconnected() {
    _isConnected = false;
    // print('MQTT Disconnected');
  }

  void _onSubscribed(String topic) {
    // print('Subscribed to topic: $topic');
  }

  Future<void> publishModeCommand(bool isAutoMode) async {
    if (!_isConnected) return;
    final payload = isAutoMode ? 'auto' : 'manual';
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client!.publishMessage(
      MqttTopics.commandMode,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  Future<void> publishBrightnessCommand(int brightness) async {
    if (!_isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(brightness.toString());
    _client!.publishMessage(
      MqttTopics.commandBrightness,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  Future<void> publishThresholdCommand(int threshold) async {
    if (!_isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(threshold.toString());
    _client!.publishMessage(
      MqttTopics.commandThreshold,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }
 
  Future<void> publishLedCommand(bool isOn) async {
    if (!_isConnected) return;
    final payload = isOn ? 'on' : 'off';
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client!.publishMessage(
      MqttTopics.commandLed,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }
 
  void disconnect() {
    _client?.disconnect();
    _isConnected = false;
    _client = null;
  }
 
  void dispose() {
    disconnect();
    _messageController.close();
  }
}