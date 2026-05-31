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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'serialNumber': serialNumber,
      'type': type,
      'lat': lat,
      'lng': lng,
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      serialNumber: json['serialNumber'] as String,
      type: json['type'] as String,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
    );
  }
}
