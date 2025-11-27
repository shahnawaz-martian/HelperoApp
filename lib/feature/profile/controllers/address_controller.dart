import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpero/feature/profile/domain/models/allowed_area_model.dart';
import 'package:http/http.dart' as http;

class AddressController extends ChangeNotifier {
  final String _googleApiKey = "AIzaSyAgcg2lbPBneSkoOwGiG5_uKHnyrvXGwMA";

  final double officeLat = 23.01280;
  final double officeLng = 72.52290;

  List<Map<String, dynamic>> suggestions = [];

  double? selectedDistance;

  void setSelectedDistance(double? distance) {
    selectedDistance = distance;
    notifyListeners();
  }

  final List<AllowedAreaModel> allowedAreaData = [
    AllowedAreaModel(
      name: "Thaltej",
      lat: 23.04997,
      lng: 72.51734,
      radiusKm: 4,
    ),
    AllowedAreaModel(
      name: "Satellite",
      lat: 23.0300,
      lng: 72.5273,
      radiusKm: 2,
    ),
    AllowedAreaModel(
      name: "Prahlad Nagar",
      lat: 23.0123,
      lng: 72.5110,
      radiusKm: 3,
    ),
    AllowedAreaModel(name: "Bopal", lat: 23.0286, lng: 72.4640, radiusKm: 3),
    AllowedAreaModel(name: "Shela", lat: 23.0169, lng: 72.4661, radiusKm: 2),
    AllowedAreaModel(
      name: "Sindhu Bhavan",
      lat: 23.0460,
      lng: 72.4992,
      radiusKm: 2,
    ),
  ];

  Future<void> getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:IN&key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        suggestions = (data['predictions'] as List)
            .where((p) {
              final description = (p['description'] as String).toLowerCase();

              return description.contains("ahmedabad");
            })
            .map(
              (p) => {
                'description': p['description'],
                'place_id': p['place_id'],
              },
            )
            .toList();

        notifyListeners();
      } else {
        debugPrint("Google API error: ${data['status']}");
      }
    } else {
      debugPrint("Error: ${response.body}");
    }
  }

  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return parseAddress(data['result']);
      } else {
        debugPrint("Place details error: ${data['status']}");
      }
    } else {
      debugPrint("Failed to fetch place details: ${response.body}");
    }
    return null;
  }

  Map<String, dynamic> parseAddress(dynamic result) {
    final components = result['address_components'] as List;

    String premise = '';
    String sublocality = '';
    String route = '';
    String locality = '';
    String state = '';
    String postalCode = '';
    String secondaryText = '';

    for (var c in components) {
      final types = List<String>.from(c['types']);
      if (types.contains('subpremise'))
        if (types.contains('premise')) {
          premise = c['long_name'];
        }
      if (types.contains('sublocality') ||
          types.contains('sublocality_level_1')) {
        sublocality = c['long_name'];
      }
      if (types.contains('route')) route = c['long_name'];
      if (types.contains('locality')) locality = c['long_name'];
      if (types.contains('administrative_area_level_1')) state = c['long_name'];
      if (types.contains('postal_code')) postalCode = c['long_name'];
    }

    String name = result['name'] ?? '';
    String nearText = '';

    // Combine building name and unit properly
    String addressLine1 = '';
    if (premise.isNotEmpty && name.isNotEmpty) {
      addressLine1 = "$premise, $name";
    } else if (premise.isNotEmpty) {
      addressLine1 = premise;
    } else if (name.isNotEmpty) {
      addressLine1 = name;
    }

    String addressLine2 = '';
    if (nearText.isNotEmpty && sublocality.isNotEmpty) {
      addressLine2 = '$nearText, $sublocality';
    } else if (route.isNotEmpty && sublocality.isNotEmpty) {
      addressLine2 = '$route, $sublocality';
    } else if (route.isNotEmpty &&
        sublocality.isNotEmpty &&
        secondaryText.isNotEmpty) {
      addressLine2 = '$secondaryText, $route $sublocality';
    } else if (sublocality.isNotEmpty) {
      addressLine2 = sublocality;
    } else if (route.isNotEmpty) {
      addressLine2 = route;
    }

    final parsed = {
      'addressLine1': addressLine1.trim(),
      'addressLine2': addressLine2.trim(),
      'city': locality,
      'state': state,
      'postalCode': postalCode,
      'latitude': result['geometry']?['location']?['lat'],
      'longitude': result['geometry']?['location']?['lng'],
    };

    debugPrint("Parsed Address: $parsed");
    return parsed;
  }

  Future<double?> getDistanceFromOffice(double destLat, double destLng) async {
    final String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json"
        "?origins=$officeLat,$officeLng"
        "&destinations=$destLat,$destLng"
        "&key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "OK" &&
          data["rows"] != null &&
          data["rows"][0]["elements"][0]["status"] == "OK") {
        final distanceValue =
            data["rows"][0]["elements"][0]["distance"]["value"];
        final distanceKm = distanceValue / 1000; // convert to km
        return distanceKm;
      } else {
        debugPrint(
          "Distance Matrix API error: ${data['rows'][0]['elements'][0]['status']}",
        );
      }
    } else {
      debugPrint("HTTP Error: ${response.statusCode}");
    }

    return null;
  }

  double _haversineDistanceKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double toRad = 3.141592653589793 / 180.0;
    final double dLat = (lat2 - lat1) * toRad;
    final double dLng = (lng2 - lng1) * toRad;

    final double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * toRad) * cos(lat2 * toRad) * (sin(dLng / 2) * sin(dLng / 2));

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    const double earthRadiusKm = 6371.0;
    return earthRadiusKm * c;
  }

  // Returns true if (lat,lng) is inside any allowed area
  Future<bool> isAllowedLocationByLatLng(double lat, double lng) async {
    for (final area in allowedAreaData) {
      final dist = _haversineDistanceKm(lat, lng, area.lat, area.lng);
      if (dist <= area.radiusKm) {
        debugPrint(
          "Inside allowed area: ${area.name} (dist: ${dist.toStringAsFixed(2)} km)",
        );
        return true;
      }
    }
    debugPrint("Not inside any allowed area");
    return false;
  }
}
