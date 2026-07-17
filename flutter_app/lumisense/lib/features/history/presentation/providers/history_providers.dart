import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/history/data/repositories/history_repository.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

final historyProvider = FutureProvider<List<HistoryRecord>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return await repository.getHistory();
});

final lastRecordProvider = FutureProvider<HistoryRecord?>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return await repository.getLastRecord();
});

final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  final records = await repository.getHistory();
  
  if (records.isEmpty) {
    return {
      'count': 0,
      'avgLdr': 0.0,
      'maxLdr': 0,
      'minLdr': 0,
      'avgBrightness': 0.0,
    };
  }
  
  final ldrValues = records.map((r) => r.ldrValue).toList();
  final brightnessValues = records.map((r) => r.brightness).toList();
  
  return {
    'count': records.length,
    'avgLdr': ldrValues.reduce((a, b) => a + b) / ldrValues.length,
    'maxLdr': ldrValues.reduce((a, b) => a > b ? a : b),
    'minLdr': ldrValues.reduce((a, b) => a < b ? a : b),
    'avgBrightness': brightnessValues.reduce((a, b) => a + b) / brightnessValues.length,
  };
});

final clearHistoryProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  await repository.clearHistory();
});

final addHistoryRecordProvider = FutureProvider.family<void, HistoryRecord>((ref, record) async {
  final repository = ref.watch(historyRepositoryProvider);
  await repository.addRecord(record);
});