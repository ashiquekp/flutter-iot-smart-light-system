import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/core/constants/app_constants.dart';
import 'package:lumisense/features/mqtt/domain/services/mqtt_service.dart';
import 'package:lumisense/shared/widgets/custom_slider.dart';

class ThresholdControlCard extends ConsumerStatefulWidget {
  const ThresholdControlCard({super.key});

  @override
  ConsumerState<ThresholdControlCard> createState() =>
      _ThresholdControlCardState();
}

class _ThresholdControlCardState extends ConsumerState<ThresholdControlCard> {
  double _threshold = AppConstants.defaultThreshold.toDouble();

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
                  'LDR Threshold',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  _threshold.round().toString(),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomSlider(
              value: _threshold,
              min: 0,
              max: 1023,
              onChanged: (value) {
                setState(() {
                  _threshold = value;
                });
                mqttService.publishThresholdCommand(value.toInt());
              },
              divisions: 1023,
              label: _threshold.round().toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Bright',
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