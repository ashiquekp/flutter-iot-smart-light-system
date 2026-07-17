import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/history/data/repositories/history_repository.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryService(repository);
});

class HistoryService {
  final HistoryRepository _repository;

  HistoryService(this._repository);

  Future<void> addRecord(HistoryRecord record) {
    return _repository.addRecord(record);
  }

  Future<List<HistoryRecord>> getHistory() {
    return _repository.getHistory();
  }

  Future<void> clearHistory() {
    return _repository.clearHistory();
  }

  Future<void> exportToCsv() {
    return _repository.exportToCsv();
  }
}