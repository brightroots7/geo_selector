# 🌍 geo_selector

A **Flutter package** that provides a simple and customizable **location picker** using **OpenStreetMap** with the `flutter_map` plugin.  

Easily **search, select, and confirm** a location, with reverse geocoding to display human-readable addresses.  

---

## ✨ Features

- 📍 Select any location on the map with a tap  
- 🔍 Search for places by address or name (OpenStreetMap **Nominatim API**)  
- 🎯 "My Location" button to quickly jump to user’s current position  
- 🏙️ Fallback default location (**New Delhi, India**) if GPS is unavailable  
- 🏠 Displays the selected location’s address  
- 🔗 Returns a **`LocationResult`** object with latitude, longitude, and address  

---



## 🚀 Installation

Add the dependency in your `pubspec.yaml`:  

```yaml
dependencies:
  geo_selector: ^0.0.1
```

Then run:
```
flutter pub get
```
## 📦 Usage
```
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geo_selector/location_selector.dart';
import 'package:geo_selector/location_result.dart';

class LocationPickerExample extends StatelessWidget {
  const LocationPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: LocationSelector(
        onLocationSelected: (LocationResult result) {
          debugPrint("Selected Location: "
              "Lat: ${result.latitude}, "
              "Lng: ${result.longitude}, "
              "Address: ${result.address}");
        },
      ),
    );
  }
}
```
# 📂 API Reference
## 🔹 LocationSelector Widget
  

| Property            | Type                        | Default     | Description |
|---------------------|-----------------------------|-------------|-------------|
| `initialLocation`   | `LatLng?`                   | New Delhi   | Initial map position if GPS not found |
| `enableMyLocation`  | `bool`                      | `true`      | Show floating "My Location" button |
| `showAddress`       | `bool`                      | `true`      | Whether to display the selected address |
| `onLocationSelected`| `Function(LocationResult)`  | *required*  | Callback when user selects a location |


## 🔹 LocationResult Model
```
class LocationResult {
  final double latitude;
  final double longitude;
  final String? address;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
```
---
## 🌍 How It Works

* Loads user’s current GPS location (falls back to New Delhi if unavailable)

* Lets the user tap anywhere on the map to select a location

* Uses OpenStreetMap Nominatim API for reverse geocoding

* Provides a search bar for address/place search

* Returns a LocationResult object


## ⚡ Dependencies

* flutter_map
* latlong2
* location
* http

## 🤝 Contribution

Contributions are welcome! 🎉  
If you’d like to improve this package, feel free to **open an issue** or **submit a pull request**.  

## ℹ️ About

📌 Repository: [geo_selector on GitHub](https://github.com/brightroots7/geo_selector/)

📌 Pub.Dev Package: [geo_selector](https://pub.dev/packages/geo_selector)

📌 Developer: [brightroots7](https://github.com/brightroots7)
