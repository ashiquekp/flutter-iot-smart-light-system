import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:lumisense/features/history/data/repositories/history_repository.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return ExportService(repository);
});

class ExportService {
  final HistoryRepository _repository;

  ExportService(this._repository);

  Future<void> exportToCsv() async {
    final records = await _repository.getHistory();
    
    if (records.isEmpty) {
      throw Exception('No data to export');
    }

    final csvData = [
      ['Timestamp', 'LDR Value', 'Brightness', 'Mode', 'LED State'],
      ...records.map((record) => [
        record.timestamp.toIso8601String(),
        record.ldrValue,
        record.brightness,
        record.isAutoMode ? 'Auto' : 'Manual',
        record.isLedOn ? 'ON' : 'OFF',
      ]),
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'lumisense_history_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(csvString);
  }
}