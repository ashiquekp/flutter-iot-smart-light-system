import 'package:flutter/material.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

class StatisticsWidget extends StatelessWidget {
  final List<HistoryRecord> records;

  const StatisticsWidget({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  context,
                  'Avg LDR',
                  stats['avgLdr'].toStringAsFixed(0),
                  Icons.timeline,
                ),
                const SizedBox(width: 8),
                _buildStatItem(
                  context,
                  'Max LDR',
                  stats['maxLdr'].toString(),
                  Icons.arrow_upward,
                ),
                const SizedBox(width: 8),
                _buildStatItem(
                  context,
                  'Min LDR',
                  stats['minLdr'].toString(),
                  Icons.arrow_downward,
                ),
                const SizedBox(width: 8),
                _buildStatItem(
                  context,
                  'Records',
                  stats['count'].toString(),
                  Icons.history,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateStats() {
    if (records.isEmpty) {
      return {
        'avgLdr': 0.0,
        'maxLdr': 0,
        'minLdr': 0,
        'count': 0,
      };
    }

    final ldrValues = records.map((r) => r.ldrValue).toList();
    final avgLdr = ldrValues.reduce((a, b) => a + b) / ldrValues.length;
    final maxLdr = ldrValues.reduce((a, b) => a > b ? a : b);
    final minLdr = ldrValues.reduce((a, b) => a < b ? a : b);

    return {
      'avgLdr': avgLdr,
      'maxLdr': maxLdr,
      'minLdr': minLdr,
      'count': records.length,
    };
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}