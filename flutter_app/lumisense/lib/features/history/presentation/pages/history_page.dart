import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/history/presentation/widgets/history_chart.dart';
import 'package:lumisense/features/history/presentation/widgets/history_list.dart';
import 'package:lumisense/features/history/presentation/widgets/statistics_widget.dart';
import 'package:lumisense/features/history/presentation/providers/history_providers.dart';
import 'package:lumisense/features/history/domain/services/export_service.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);
    // ignore: unused_local_variable
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Statistics'),
        actions: [
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final exportService = ref.read(exportServiceProvider);
              await exportService.exportToCsv();
              if (mounted) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('CSV exported successfully'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: historyState.when(
        data: (records) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatisticsWidget(records: records),
                const SizedBox(height: 16),
                if (_showChart)
                  HistoryChart(records: records)
                else
                  HistoryList(records: records),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading history: $error'),
        ),
      ),
    );
  }
}