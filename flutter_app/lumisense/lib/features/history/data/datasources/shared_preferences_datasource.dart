import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumisense/features/history/domain/models/history_record.dart';

final sharedPreferencesDatasourceProvider = Provider<SharedPreferencesDatasource>((ref) {
  return SharedPreferencesDatasource();
});

class SharedPreferencesDatasource {
  static const String _keyLastRecord = 'lumisense_last_record';
  static const String _keyThreshold = 'lumisense_threshold';
  static const String _keyMode = 'lumisense_mode';
  static const String _keyBrightness = 'lumisense_brightness';
  static const String _keySettings = 'lumisense_settings';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Last Record
  Future<void> saveLastRecord(HistoryRecord record) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyLastRecord, jsonEncode(record.toJson()));
  }

  Future<HistoryRecord?> getLastRecord() async {
    final prefs = await _getPrefs();
    final String? recordJson = prefs.getString(_keyLastRecord);
    if (recordJson == null) return null;
    try {
      return HistoryRecord.fromJson(jsonDecode(recordJson));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearLastRecord() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyLastRecord);
  }

  // Threshold
  Future<void> saveThreshold(int threshold) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyThreshold, threshold);
  }

  Future<int> getThreshold() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyThreshold) ?? 500;
  }

  // Mode
  Future<void> saveMode(bool isAutoMode) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyMode, isAutoMode);
  }

  Future<bool> getMode() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyMode) ?? true;
  }

  // Brightness
  Future<void> saveBrightness(int brightness) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyBrightness, brightness);
  }

  Future<int> getBrightness() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyBrightness) ?? 128;
  }

  // Settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keySettings, jsonEncode(settings));
  }

  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await _getPrefs();
    final String? settingsJson = prefs.getString(_keySettings);
    if (settingsJson == null) {
      return {
        'notificationsEnabled': true,
        'autoMode': true,
        'brightness': 128,
        'threshold': 500,
      };
    }
    try {
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    } catch (e) {
      return {
        'notificationsEnabled': true,
        'autoMode': true,
        'brightness': 128,
        'threshold': 500,
      };
    }
  }
}