import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/history/data/repositories/history_repository.dart';
import 'package:lumisense/features/settings/domain/models/app_settings.dart';
import 'package:lumisense/features/settings/domain/services/settings_service.dart';

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  final service = ref.watch(settingsServiceProvider);
  return await service.loadSettings();
});

final updateSettingsProvider = FutureProvider.family<void, AppSettings>((ref, settings) async {
  final service = ref.watch(settingsServiceProvider);
  await service.saveSettings(settings);
});

final updateAutoModeProvider = FutureProvider.family<void, bool>((ref, autoMode) async {
  final service = ref.watch(settingsServiceProvider);
  await service.updateAutoMode(autoMode);
});

final updateNotificationsProvider = FutureProvider.family<void, bool>((ref, enabled) async {
  final service = ref.watch(settingsServiceProvider);
  await service.updateNotifications(enabled);
});

final updateBrightnessProvider = FutureProvider.family<void, int>((ref, brightness) async {
  final service = ref.watch(settingsServiceProvider);
  await service.updateBrightness(brightness);
});

final updateThresholdProvider = FutureProvider.family<void, int>((ref, threshold) async {
  final service = ref.watch(settingsServiceProvider);
  await service.updateThreshold(threshold);
});

// Settings notifier for local state management
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final service = ref.read(settingsServiceProvider);
      final settings = await service.loadSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateAutoMode(bool autoMode) async {
    try {
      final currentState = state;
      if (currentState.hasValue) {
        final currentSettings = currentState.value!;
        final updatedSettings = AppSettings(
          autoMode: autoMode,
          notificationsEnabled: currentSettings.notificationsEnabled,
          brightness: currentSettings.brightness,
          threshold: currentSettings.threshold,
        );
        state = AsyncValue.data(updatedSettings);
        
        final service = ref.read(settingsServiceProvider);
        await service.updateAutoMode(autoMode);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateNotifications(bool enabled) async {
    try {
      final currentState = state;
      if (currentState.hasValue) {
        final currentSettings = currentState.value!;
        final updatedSettings = AppSettings(
          autoMode: currentSettings.autoMode,
          notificationsEnabled: enabled,
          brightness: currentSettings.brightness,
          threshold: currentSettings.threshold,
        );
        state = AsyncValue.data(updatedSettings);
        
        final service = ref.read(settingsServiceProvider);
        await service.updateNotifications(enabled);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearHistory() async {
    try {
      final historyRepository = ref.read(historyRepositoryProvider);
      await historyRepository.clearHistory();
      // Update settings state after clearing history
      final service = ref.read(settingsServiceProvider);
      final settings = await service.loadSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshSettings() async {
    await _loadSettings();
  }
}