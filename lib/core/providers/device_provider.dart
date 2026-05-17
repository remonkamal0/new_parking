import 'package:flutter/material.dart';
import 'package:test888/core/models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void addDevice(DeviceModel device) {
    _devices.add(device);
    notifyListeners();
  }

  void updateDevice(String id, {String? name, String? location, double? lat, double? lng}) {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(
        name: name,
        location: location,
        lat: lat,
        lng: lng,
      );
      notifyListeners();
    }
  }

  void removeDevice(String id) {
    _devices.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}
