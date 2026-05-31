import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test888/core/models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  static const _prefsKey = 'saved_devices';
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey);
    if (list == null) return;

    _devices.clear();
    for (final item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        _devices.add(DeviceModel.fromJson(map));
      } catch (e) {
        debugPrint('Error decoding device: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _devices.map((device) => jsonEncode(device.toJson())).toList();
    await prefs.setStringList(_prefsKey, list);
  }

  Future<void> addDevice(DeviceModel device) async {
    _devices.add(device);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> updateDevice(String id, {String? name, String? location, double? lat, double? lng}) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(
        name: name,
        location: location,
        lat: lat,
        lng: lng,
      );
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> removeDevice(String id) async {
    _devices.removeWhere((d) => d.id == id);
    notifyListeners();
    await _saveToPrefs();
  }
}
