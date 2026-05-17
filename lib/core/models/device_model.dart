class DeviceModel {
  String id;
  String name;
  String location;
  String serialNumber;
  String type; // e.g., 'terminal' or 'bouncer'
  double? lat;
  double? lng;

  DeviceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.serialNumber,
    required this.type,
    this.lat,
    this.lng,
  });

  // Copy with for updating fields
  DeviceModel copyWith({
    String? id,
    String? name,
    String? location,
    String? serialNumber,
    String? type,
    double? lat,
    double? lng,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      serialNumber: serialNumber ?? this.serialNumber,
      type: type ?? this.type,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
