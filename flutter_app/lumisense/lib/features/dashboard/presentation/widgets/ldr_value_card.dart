import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/dashboard/presentation/providers/dashboard_providers.dart';

class LdrValueCard extends ConsumerWidget {
  const LdrValueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ldrValue = ref.watch(ldrValueProvider);
    final theme = Theme.of(context);

    // Determine the status based on LDR value
    String status;
    Color statusColor;
    IconData statusIcon;

    if (ldrValue < 300) {
      status = 'Dark';
      statusColor = Colors.blue;
      statusIcon = Icons.nightlight_round;
    } else if (ldrValue < 600) {
      status = 'Dim';
      statusColor = Colors.orange;
      statusIcon = Icons.wb_twilight;
    } else {
      status = 'Bright';
      statusColor = Colors.yellow;
      statusIcon = Icons.wb_sunny;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LDR Value',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ldrValue.toString(),
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    size: 40,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: ldrValue / 1023,
              backgroundColor: Colors.grey.shade200,
              color: statusColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '512',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '1023',
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