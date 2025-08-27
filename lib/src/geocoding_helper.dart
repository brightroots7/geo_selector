import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingHelper {
  /// 🔹 Convert LatLng → Address
  static Future<String?> getAddressFromLatLng(double lat, double lon) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon");

    final response = await http.get(url, headers: {"User-Agent": "location_selector_app"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["display_name"];
    }
    return null;
  }

  /// 🔹 Convert Address → LatLng
  static Future<LatLng?> getLatLngFromAddress(String query) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1");

    final response = await http.get(url, headers: {"User-Agent": "location_selector_app"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]["lat"]);
        final lon = double.parse(data[0]["lon"]);
        return LatLng(lat, lon);
      }
    }
    return null;
  }
}
