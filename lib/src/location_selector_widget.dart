import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'geocoding_helper.dart';
import 'location_result.dart';

class LocationSelector extends StatefulWidget {
  final LatLng? initialLocation;
  final bool enableMyLocation;
  final bool showAddress;
  final Function(LocationResult) onLocationSelected;

  const LocationSelector({
    super.key,
    this.initialLocation,
    this.enableMyLocation = true,
    this.showAddress = true,
    required this.onLocationSelected,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      Location location = Location();

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission == PermissionStatus.granted) {
        final locData = await location.getLocation();
        _setLocation(LatLng(locData.latitude!, locData.longitude!));
        return;
      }
    } catch (_) {}

    // fallback New Delhi
    _setLocation(const LatLng(28.6139, 77.2090));
  }

  Future<void> _setLocation(LatLng pos) async {
    setState(() => _selectedLocation = pos);

    if (widget.showAddress) {
      final addr =
      await GeocodingHelper.getAddressFromLatLng(pos.latitude, pos.longitude);
      setState(() => _selectedAddress = addr);
    }

    widget.onLocationSelected(LocationResult(
      latitude: pos.latitude,
      longitude: pos.longitude,
      address: _selectedAddress,
    ));

    _mapController.move(pos, 14);
  }

  Future<void> _goToMyLocation() async {
    Location location = Location();
    final locData = await location.getLocation();
    final myPos = LatLng(locData.latitude!, locData.longitude!);
    _setLocation(myPos);
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final result = await GeocodingHelper.getLatLngFromAddress(query);
    if (result != null) {
      _setLocation(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _selectedLocation == null
        ? const Center(child: CircularProgressIndicator())
        : Stack(
      children: [
        // 🗺️ Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedLocation!,
            initialZoom: 14,
            onTap: (tapPosition, point) => _setLocation(point),
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            if (_selectedLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: _selectedLocation!,
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 40),
                  )
                ],
              ),
          ],
        ),

        // 🔍 Search bar (ALWAYS ON TOP)
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search location...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.blue),
                    onPressed: _searchLocation,
                  ),
                ],
              ),
            ),
          ),
        ),

        // 📌 Address display
        if (widget.showAddress && _selectedAddress != null)
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedAddress!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        // 🎯 My Location Button
        if (widget.enableMyLocation)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: _goToMyLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
      ],
    );
  }
}
