import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static const _notificationPermission = Permission.notification;
  static const _storagePermission = Permission.storage;

  static Future<bool> requestNotificationPermission() async {
    final status = await _notificationPermission.request();
    return status.isGranted;
  }

  static Future<bool> checkNotificationPermission() async {
    final status = await _notificationPermission.status;
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await _storagePermission.request();
    return status.isGranted;
  }

  static Future<bool> checkStoragePermission() async {
    final status = await _storagePermission.status;
    return status.isGranted;
  }

  static Future<bool> requestAllPermissions() async {
    final List<Permission> permissions = [
      _notificationPermission,
      _storagePermission,
    ];
    
    final Map<Permission, PermissionStatus> statuses = 
        await permissions.request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  static Future<Map<Permission, PermissionStatus>> checkAllPermissions() async {
    final List<Permission> permissions = [
      _notificationPermission,
      _storagePermission,
    ];
    
    final Map<Permission, PermissionStatus> statuses = {};
    for (final permission in permissions) {
      statuses[permission] = await permission.status;
    }
    return statuses;
  }

  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'LumiSense needs notification and storage permissions to function properly. '
          'Please grant these permissions in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  static Future<bool> handlePermissionRequest() async {
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission) {
      final granted = await requestNotificationPermission();
      if (!granted) {
        return false;
      }
    }
    return true;
  }
}