import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/core/widgets/loading_widget.dart';
import 'package:lumisense/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/device_status_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/mqtt_status_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/light_control_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/brightness_control_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/threshold_control_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/ldr_value_card.dart';
import 'package:lumisense/features/dashboard/presentation/widgets/mode_control_card.dart';
import 'package:lumisense/features/mqtt/presentation/providers/mqtt_providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the MQTT message listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardInitProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access ref directly from the ConsumerState
    final mqttState = ref.watch(mqttConnectionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(mqttConnectionProvider.notifier).reconnect();
            },
          ),
        ],
      ),
      body: mqttState.when(
        data: (isConnected) {
          if (!isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Not Connected to MQTT',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your internet connection',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(mqttConnectionProvider.notifier).reconnect();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reconnect'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Refresh data
            },
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MqttStatusCard(isConnected: true),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DeviceStatusCard(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  LdrValueCard(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LightControlCard(),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ModeControlCard(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  BrightnessControlCard(),
                  SizedBox(height: 16),
                  ThresholdControlCard(),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}