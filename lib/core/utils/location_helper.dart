import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final String address;
  final double lat;
  final double lng;

  LocationResult({required this.address, required this.lat, required this.lng});
}

class LocationHelper {
  /// Fetches the current GPS position and returns address + coordinates.
  static Future<LocationResult?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = 'Unknown Location';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final parts = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.locality != null && place.locality!.isNotEmpty) place.locality,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ];
        address = parts.join(', ');
      }

      return LocationResult(
        address: address,
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  /// Convenience method to get only the address string (backward compat).
  static Future<String> getCurrentAddress() async {
    final result = await getCurrentLocation();
    return result?.address ?? 'Unknown Location';
  }
}
