class LocationResult {
  final double latitude;
  final double longitude;
  final String? address;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  String toString() => "Lat: $latitude, Lng: $longitude, Address: $address";
}
