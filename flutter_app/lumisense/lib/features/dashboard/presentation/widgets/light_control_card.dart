import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';

class LightControlCard extends ConsumerStatefulWidget {
  const LightControlCard({super.key});

  @override
  ConsumerState<LightControlCard> createState() => _LightControlCardState();
}

class _LightControlCardState extends ConsumerState<LightControlCard> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    final mqttService = ref.read(mqttServiceProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'LED Control',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${_isOn ? "ON" : "OFF"}',
                  style: theme.textTheme.bodyLarge,
                ),
                Switch(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                    mqttService.publishLedCommand(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}