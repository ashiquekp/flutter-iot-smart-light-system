import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart' hide MqttMessage;
import 'package:lumisense/core/constants/app_constants.dart';
import 'package:lumisense/core/constants/mqtt_topics.dart';
import 'package:lumisense/features/mqtt/domain/models/mqtt_message.dart';

// Use a prefix for the mqtt_client library to avoid naming conflicts
// import 'package:mqtt_client/mqtt_client.dart' as mqtt_lib;
import 'package:mqtt_client/mqtt_server_client.dart';

final mqttDatasourceProvider = Provider<MqttDatasource>((ref) {
  return MqttDatasource();
});

class MqttDatasource {
  MqttServerClient? _client;
  final StreamController<MqttMessage> _messageController =
      StreamController.broadcast();
  bool _isConnected = false;
  StreamSubscription? _subscription;

  Stream<MqttMessage> getMessages() => _messageController.stream;
 
  bool isConnected() => _isConnected;
 
  Future<void> connect() async {
    try {
      // print('🔄 Connecting to MQTT broker: ${AppConstants.mqttBroker}');
      
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
      // print('MQTT connection attempt completed');

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;
        // print('✅ MQTT connected successfully');
        _subscribeToTopics();
        _setupMessageListener();
      } else {
        // print('❌ MQTT connection failed with state: ${_client!.connectionStatus!.state}');
        throw Exception('Failed to connect to MQTT broker');
      }
    } catch (e) {
      // print('❌ MQTT error: $e');
      throw Exception('MQTT connection error: $e');
    }
  }

  void _setupMessageListener() {
    // Cancel any existing subscription 
    _subscription?.cancel();
    
    // Get the updates stream 
    final updates = _client?.updates;
    if (updates != null) {
      // Explicitly cast the stream type 
      _subscription = updates.cast<List<MqttReceivedMessage<MqttMessage>>>().listen(
        (messages) {
          _handleIncomingMessage(messages);
        },
        onError: (error) {
          // print('❌ MQTT stream error: $error');
        },
        cancelOnError: false,
      );
      // print('📡 Listening for MQTT messages');
    }
  }

  void _subscribeToTopics() {
    final topics = [
      MqttTopics.ldrValue,
      MqttTopics.deviceStatus,
      MqttTopics.deviceMode,
      MqttTopics.deviceBrightness,
      MqttTopics.ledStatus,
    ];
    for (final topic in topics) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
      // print('📡 Subscribed to: $topic');
    }
  }

  void _handleIncomingMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final message in messages) {
      final topic = message.topic;
      if (message.payload is MqttPublishMessage) {
        final payload = (message.payload as MqttPublishMessage).payload.message;
        final payloadString = String.fromCharCodes(payload);
        // print('📨 Received: $topic -> $payloadString');
        
        final mqttMessage = MqttMessage(
          topic: topic,
          payload: payloadString,
          timestamp: DateTime.now(),
        );
        _messageController.add(mqttMessage);
      }
    }
  }
 
  void _onConnected() {
    _isConnected = true;
    // print('✅ MQTT Connected');
  }
 
  void _onDisconnected() {
    _isConnected = false;
    // print('❌ MQTT Disconnected');
  }
 
  void _onSubscribed(String topic) {
    // print('📡 Subscribed to topic: $topic');
  }

  Future<void> publish(String topic, String payload, {required bool retained}) async {
    if (!_isConnected || _client == null) {
      // print('⚠️ Cannot publish - not connected');
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
    // print('📤 Published: $topic -> $payload');
  }

  Future<void> subscribe(String topic) async {
    if (!_isConnected || _client == null) return;
    _client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  Future<void> unsubscribe(String topic) async {
    if (!_isConnected || _client == null) return;
    _client!.unsubscribe(topic);
  }

  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    _client?.disconnect();
    _isConnected = false;
    _client = null;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    disconnect();
    _messageController.close();
  }
}