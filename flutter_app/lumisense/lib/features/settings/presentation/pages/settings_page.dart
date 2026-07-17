import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/core/constants/app_constants.dart';
import 'package:lumisense/features/settings/presentation/providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        data: (settingsData) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Auto Mode'),
                subtitle: const Text('Automatically adjust brightness'),
                value: settingsData.autoMode,
                onChanged: (value) {
                  // Use the settings notifier provider instead
                  ref.read(settingsNotifierProvider.notifier).updateAutoMode(value);
                },
              ),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive notifications about light changes'),
                value: settingsData.notificationsEnabled,
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).updateNotifications(value);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Clear History'),
                subtitle: const Text('Remove all history data'),
                leading: const Icon(Icons.delete, color: Colors.red),
                onTap: () => _showClearHistoryDialog(context, ref),
              ),
              const Divider(),
              const AboutListTile(
                applicationName: AppConstants.appName,
                applicationVersion: AppConstants.appVersion,
                applicationIcon: Icon(Icons.lightbulb),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text(
            'Are you sure you want to clear all history data? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Use the clear history function from the notifier
                ref.read(settingsNotifierProvider.notifier).clearHistory();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History cleared successfully'),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}