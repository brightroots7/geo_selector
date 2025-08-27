# geo_selector

A Flutter package that provides a simple and customizable **location picker** using **OpenStreetMap** with the `flutter_map` plugin.  
It allows users to **search, select, and confirm** a location, with reverse geocoding support to display human-readable addresses.

---

## ✨ Features
- 📍 Select any location on the map with a tap
- 🔍 Search for places by address or name (OpenStreetMap Nominatim API)
- 🎯 "My Location" button to quickly jump to user’s current position
- 🏙️ Fallback default location (New Delhi, India) if GPS is unavailable
- 🏠 Shows selected location’s address
- 🔗 Returns a `LocationResult` object with latitude, longitude, and address

---

## 📸 Screenshot
*(Add your package screenshot here)*

---

## 🚀 Installation

Add dependency in `pubspec.yaml`:

```yaml
dependencies:
  location_selector: ^0.0.1
Run:
flutter pub get
📦 Usage
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_selector/location_selector.dart';
import 'package:location_selector/location_result.dart';

class LocationPickerExample extends StatelessWidget {
  const LocationPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: LocationSelector(
        onLocationSelected: (LocationResult result) {
          debugPrint("Selected Location: "
              "Lat: ${result.latitude}, Lng: ${result.longitude}, Address: ${result.address}");
        },
      ),
    );
  }
}
📂 API Reference
LocationSelector Widget
Property	Type	Default	Description
initialLocation	LatLng?	New Delhi	Initial map position if GPS not found
enableMyLocation	bool	true	Show floating "My Location" button
showAddress	bool	true	Whether to display the selected address
onLocationSelected	Function(LocationResult)	required	Callback when user selects a location
LocationResult Model
class LocationResult {
  final double latitude;
  final double longitude;
  final String? address;
}
🌍 How It Works
Loads user’s current GPS location (falls back to New Delhi if unavailable)
Lets the user tap anywhere on the map to select a location
Uses OpenStreetMap Nominatim API for reverse geocoding
Provides a search bar for address/place search
⚡ Dependencies
flutter_map
latlong2
location
http
