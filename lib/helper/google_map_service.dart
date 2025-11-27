import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleMapService {
  final String apiKey;

  GoogleMapService({required this.apiKey});

  Future<Map<String, double>?> getLatLngFromAddress(String address) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final location = data["results"][0]["geometry"]["location"];
      return {"lat": location["lat"], "lng": location["lng"]};
    } else {
      debugPrint("Failed to get coordinates: ${data['status']}");
      return null;
    }
  }

  Future<double> getDistanceInKm({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json?"
      "origins=$originLat,$originLng&destinations=$destLat,$destLng&key=$apiKey",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final distanceText = data["rows"][0]["elements"][0]["distance"]["text"];
      final distanceValue = data["rows"][0]["elements"][0]["distance"]["value"];
      return distanceValue / 1000;
    } else {
      throw Exception("Failed to calculate distance");
    }
  }
}
