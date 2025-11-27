import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static Future<Map<String, dynamic>?> getCurrentAddressDetails() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // permission = await Geolocator.requestPermission();
        // if (permission == LocationPermission.denied)
        return null;
      }
      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        return {
          'addressLine1': place.street ?? '',
          'addressLine2': place.subLocality ?? '',
          'city': place.locality ?? '',
          'state': place.administrativeArea ?? '',
          'postalCode': place.postalCode ?? '',
          'latitude': position.latitude,
          'longitude': position.longitude,
          'formattedAddress':
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}",
        };
      }
    } catch (e) {}
    return null;
  }

  // You can keep this old helper for quick string fetch
  static Future<String?> getCurrentAddress() async {
    final details = await getCurrentAddressDetails();
    return details?['formattedAddress'];
  }

  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<String> getApproxLocation() async {
    try {
      final response = await http.get(Uri.parse("https://ipapi.co/json/"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return "${data['city']}, ${data['region']}";
      }
    } catch (_) {}

    return "Location unavailable";
  }
}
