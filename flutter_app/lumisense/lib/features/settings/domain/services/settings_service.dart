import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/settings/domain/models/app_settings.dart';
import 'package:lumisense/features/history/data/datasources/shared_preferences_datasource.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final datasource = ref.watch(sharedPreferencesDatasourceProvider);
  return SettingsService(datasource);
});

class SettingsService {
  final SharedPreferencesDatasource _datasource;

  SettingsService(this._datasource);

  Future<AppSettings> loadSettings() async {
    final threshold = await _datasource.getThreshold();
    final isAutoMode = await _datasource.getMode();
    final brightness = await _datasource.getBrightness();
    final settingsMap = await _datasource.getSettings();
    
    return AppSettings(
      autoMode: settingsMap['autoMode'] ?? isAutoMode,
      notificationsEnabled: settingsMap['notificationsEnabled'] ?? true,
      brightness: settingsMap['brightness'] ?? brightness,
      threshold: settingsMap['threshold'] ?? threshold,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _datasource.saveThreshold(settings.threshold);
    await _datasource.saveMode(settings.autoMode);
    await _datasource.saveBrightness(settings.brightness);
    await _datasource.saveSettings({
      'autoMode': settings.autoMode,
      'notificationsEnabled': settings.notificationsEnabled,
      'brightness': settings.brightness,
      'threshold': settings.threshold,
    });
  }

  Future<void> updateAutoMode(bool autoMode) async {
    await _datasource.saveMode(autoMode);
    final settings = await loadSettings();
    await _datasource.saveSettings({
      'autoMode': autoMode,
      'notificationsEnabled': settings.notificationsEnabled,
      'brightness': settings.brightness,
      'threshold': settings.threshold,
    });
  }

  Future<void> updateNotifications(bool enabled) async {
    final settings = await loadSettings();
    await _datasource.saveSettings({
      'autoMode': settings.autoMode,
      'notificationsEnabled': enabled,
      'brightness': settings.brightness,
      'threshold': settings.threshold,
    });
  }

  Future<void> updateBrightness(int brightness) async {
    await _datasource.saveBrightness(brightness);
    final settings = await loadSettings();
    await _datasource.saveSettings({
      'autoMode': settings.autoMode,
      'notificationsEnabled': settings.notificationsEnabled,
      'brightness': brightness,
      'threshold': settings.threshold,
    });
  }

  Future<void> updateThreshold(int threshold) async {
    await _datasource.saveThreshold(threshold);
    final settings = await loadSettings();
    await _datasource.saveSettings({
      'autoMode': settings.autoMode,
      'notificationsEnabled': settings.notificationsEnabled,
      'brightness': settings.brightness,
      'threshold': threshold,
    });
  }
}