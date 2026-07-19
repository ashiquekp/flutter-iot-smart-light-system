import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/features/dashboard/domain/models/device_status.dart';
import 'package:lumisense/features/dashboard/domain/models/light_data.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

class DeviceService {
  DeviceStatus _status = const DeviceStatus(
    online: false,
    uptime: '00:00:00',
  );
  
  LightData _lightData = const LightData(
    ldrValue: 0,
    brightness: 128,
    isAutoMode: true,
    isLedOn: false,
  );

  DeviceStatus getStatus() => _status;
  LightData getLightData() => _lightData;

  void updateStatus(DeviceStatus status) {
    _status = status;
  }

  void updateLightData(LightData data) {
    _lightData = data;
  }

  bool isDeviceOnline() => _status.online;

  String getUptime() => _status.uptime;

  int getLdrValue() => _lightData.ldrValue;

  int getBrightness() => _lightData.brightness;

  bool isAutoMode() => _lightData.isAutoMode;

  bool isLedOn() => _lightData.isLedOn;

  String getStatusDescription() {
    if (!_status.online) return 'Device Offline';
    if (_lightData.isLedOn) {
      return 'LED ON at ${_lightData.brightness}%';
    }
    return 'LED OFF';
  }

  String getModeDescription() {
    return _lightData.isAutoMode ? 'Auto Mode' : 'Manual Mode';
  }
}