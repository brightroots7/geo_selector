import 'package:flutter/material.dart';
import 'package:geo_selector/geo_selector.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Location Selector Example")),
        body: GeoSelector(
          initialLocation: const LatLng(28.6139, 77.2090),
          enableMyLocation: true,
          showAddress: true,
          enableSearch: true, // This enables the search bar
          onLocationSelected: (result) {
            print("Selected => $result");
          },
        ),
      ),
    );
  }
}