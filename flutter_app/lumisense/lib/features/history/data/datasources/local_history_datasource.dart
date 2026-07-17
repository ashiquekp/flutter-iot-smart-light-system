import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumisense/core/constants/app_constants.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

final localHistoryDatasourceProvider = Provider<LocalHistoryDatasource>((ref) {
  return LocalHistoryDatasource();
});

class LocalHistoryDatasource {
  static const String _keyHistory = 'lumisense_history';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> addRecord(HistoryRecord record) async {
    final prefs = await _getPrefs();
    final List<String>? existing = prefs.getStringList(_keyHistory);
    final List<String> records = existing ?? [];
    
    // Add new record
    records.add(jsonEncode(record.toJson()));
    
    // Limit to max history items
    while (records.length > AppConstants.maxHistoryItems) {
      records.removeAt(0);
    }
    
    await prefs.setStringList(_keyHistory, records);
  }

  Future<List<HistoryRecord>> getRecords() async {
    final prefs = await _getPrefs();
    final List<String>? records = prefs.getStringList(_keyHistory);
    
    if (records == null || records.isEmpty) {
      return [];
    }
    
    // Parse records and filter by retention period
    final now = DateTime.now();
    final retentionLimit = now.subtract(const Duration(days: AppConstants.historyRetentionDays));
    
    final parsedRecords = records
        .map((record) => HistoryRecord.fromJson(jsonDecode(record)))
        .where((record) => record.timestamp.isAfter(retentionLimit))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return parsedRecords;
  }

  Future<void> clearRecords() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyHistory);
  }

  Future<int> getRecordCount() async {
    final prefs = await _getPrefs();
    final List<String>? records = prefs.getStringList(_keyHistory);
    return records?.length ?? 0;
  }
}