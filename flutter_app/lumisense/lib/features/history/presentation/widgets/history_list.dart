import 'package:flutter/material.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';
import 'package:lumisense/core/utils/date_formatter.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryRecord> records;

  const HistoryList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No history records available'),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final recentRecords = records.take(100).toList();

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentRecords.length,
        itemBuilder: (context, index) {
          final record = recentRecords[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                record.ldrValue.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              'LDR: ${record.ldrValue}',
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Brightness: ${record.brightness} | Mode: ${record.isAutoMode ? "Auto" : "Manual"}',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Text(
              DateFormatter.formatDateTime(record.timestamp),
              style: theme.textTheme.bodySmall,
            ),
            isThreeLine: false,
          );
        },
      ),
    );
  }
}