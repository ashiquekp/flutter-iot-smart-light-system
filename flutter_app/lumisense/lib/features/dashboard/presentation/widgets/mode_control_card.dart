import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';

class ModeControlCard extends ConsumerStatefulWidget {
  const ModeControlCard({super.key});

  @override
  ConsumerState<ModeControlCard> createState() => _ModeControlCardState();
}

class _ModeControlCardState extends ConsumerState<ModeControlCard> {
  bool _isAutoMode = true;

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
              'Mode Control',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _isAutoMode ? 'Auto Mode' : 'Manual Mode',
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      _isAutoMode ? 'Adjusts automatically' : 'Manual control',
                      style: theme.textTheme.bodySmall,
                    ),
                    Switch(
                      value: _isAutoMode,
                      onChanged: (value) {
                        setState(() {
                          _isAutoMode = value;
                        });
                        mqttService.publishModeCommand(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
