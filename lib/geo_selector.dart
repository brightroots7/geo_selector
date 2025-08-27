import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_selector/src/geocoding_helper.dart';
import 'package:geo_selector/src/location_result.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GeoSelector extends StatefulWidget {
  final LatLng? initialLocation;
  final bool enableMyLocation;
  final bool showAddress;
  final bool enableSearch;
  final Function(LocationResult) onLocationSelected;

  const GeoSelector({
    super.key,
    this.initialLocation,
    this.enableMyLocation = true,
    this.showAddress = true,
    this.enableSearch = true,
    required this.onLocationSelected,
  });

  @override
  State<GeoSelector> createState() => _GeoSelectorState();
}

class _GeoSelectorState extends State<GeoSelector> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? const LatLng(28.6139, 77.2090); // Default: Delhi
    _updateAddress(_selectedLocation!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress(LatLng position) async {
    if (!widget.showAddress) return;
    final addr = await GeocodingHelper.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );
    setState(() => _selectedAddress = addr);
  }

  Future<void> _goToMyLocation() async {
    Location location = Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }

    final locData = await location.getLocation();
    final myPos = LatLng(locData.latitude!, locData.longitude!);

    _mapController.move(myPos, 16);
    _onMapTap(myPos);
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _updateAddress(position);

    widget.onLocationSelected(
      LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        address: _selectedAddress,
      ),
    );
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final result = await GeocodingHelper.getLatLngFromAddress(query);
    if (result != null) {
      _mapController.move(result, 14);
      _onMapTap(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedLocation!,
            initialZoom: 13,
            onTap: (tapPos, point) => _onMapTap(point),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.example.geo_selector",
            ),
            if (_selectedLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation!,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),

        // Search Bar
        if (widget.enableSearch)
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
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

        // My Location Button
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

        // Address display
        if (widget.showAddress && _selectedAddress != null)
          Positioned(
            bottom: widget.enableMyLocation ? 80 : 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _selectedAddress!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}