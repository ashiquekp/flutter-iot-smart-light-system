import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/history/data/datasources/local_history_datasource.dart';
import 'package:lumisense/features/history/data/datasources/shared_preferences_datasource.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final localDatasource = ref.watch(localHistoryDatasourceProvider);
  final sharedPrefsDatasource = ref.watch(sharedPreferencesDatasourceProvider);
  return HistoryRepository(localDatasource, sharedPrefsDatasource);
});

class HistoryRepository {
  final LocalHistoryDatasource _localDatasource;
  final SharedPreferencesDatasource _sharedPrefsDatasource;

  HistoryRepository(this._localDatasource, this._sharedPrefsDatasource);

  Future<void> addRecord(HistoryRecord record) async {
    await _localDatasource.addRecord(record);
    await _sharedPrefsDatasource.saveLastRecord(record);
  }

  Future<List<HistoryRecord>> getHistory() async {
    return await _localDatasource.getRecords();
  }

  Future<void> clearHistory() async {
    await _localDatasource.clearRecords();
    await _sharedPrefsDatasource.clearLastRecord();
  }

  Future<int> getRecordCount() async {
    final records = await _localDatasource.getRecords();
    return records.length;
  }

  Future<HistoryRecord?> getLastRecord() async {
    return await _sharedPrefsDatasource.getLastRecord();
  }

  Future<double> getAverageLdr() async {
    final records = await _localDatasource.getRecords();
    if (records.isEmpty) return 0.0;
    final sum = records.fold<int>(0, (sum, record) => sum + record.ldrValue);
    return sum / records.length;
  }

  Future<int> getMaxLdr() async {
    final records = await _localDatasource.getRecords();
    if (records.isEmpty) return 0;
    return records.fold<int>(0, (max, record) => record.ldrValue > max ? record.ldrValue : max);
  }

  Future<int> getMinLdr() async {
    final records = await _localDatasource.getRecords();
    if (records.isEmpty) return 0;
    return records.fold<int>(1023, (min, record) => record.ldrValue < min ? record.ldrValue : min);
  }

  Future<double> getAverageBrightness() async {
    final records = await _localDatasource.getRecords();
    if (records.isEmpty) return 0.0;
    final sum = records.fold<int>(0, (sum, record) => sum + record.brightness);
    return sum / records.length;
  }

  Future<void> exportToCsv() async {
    // ignore: unused_local_variable
    final records = await _localDatasource.getRecords();
    // CSV export logic will be handled by ExportService
    // This is just a placeholder
  }
}