import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';
import 'package:lumisense/shared/widgets/custom_slider.dart';

class BrightnessControlCard extends ConsumerStatefulWidget {
  const BrightnessControlCard({super.key});

  @override
  ConsumerState<BrightnessControlCard> createState() =>
      _BrightnessControlCardState();
}

class _BrightnessControlCardState extends ConsumerState<BrightnessControlCard> {
  double _brightness = 128;

  @override
  Widget build(BuildContext context) {
    final mqttService = ref.read(mqttServiceProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Brightness',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '${_brightness.round()}%',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomSlider(
              value: _brightness,
              min: 0,
              max: 255,
              onChanged: (value) {
                setState(() {
                  _brightness = value;
                });
                mqttService.publishBrightnessCommand(value.toInt());
              },
              divisions: 255,
              label: _brightness.round().toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '50%',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '100%',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}