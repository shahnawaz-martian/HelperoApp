import 'package:flutter/foundation.dart';

import 'location_helper.dart';

import 'package:flutter/material.dart';

class LocationController with ChangeNotifier {
  String? _currentAddress;
  Map<String, dynamic>? _currentAddressDetails;
  bool _isLoading = false;

  String? get currentAddress => _currentAddress;
  Map<String, dynamic>? get currentAddressDetails => _currentAddressDetails;
  bool get isLoading => _isLoading;

  Future<void> fetchCurrentAddress({bool forceRefresh = false}) async {
    if (!forceRefresh && _currentAddress != null && _currentAddress!.isNotEmpty) return;

    // CHECK permission but DO NOT request it
    final hasPermission = await LocationHelper.hasLocationPermission();
    if (!hasPermission) {
      _currentAddress = "Location permission not granted";
      notifyListeners();
      return;
    }

    print(hasPermission);

    _isLoading = true;
    notifyListeners();

    try {
      final details = await LocationHelper.getCurrentAddressDetails();

      print(details);
      if (details != null) {
        _currentAddressDetails = details;
        _currentAddress = details['formattedAddress'];
      } else {
        _currentAddress = "Unable to fetch location";
      }
    } catch (e) {
      _currentAddress = "Unable to fetch location";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getCurrentLocationDetails() async {
    final details = await LocationHelper.getCurrentAddressDetails();
    if (details != null) {
      _currentAddressDetails = details;
      _currentAddress = details['formattedAddress'];
      notifyListeners();
    }

    print("Details $details");
    return details;
  }

  Future<void> fetchApproxLocation() async {
    print("Here i m");
    _currentAddress = await LocationHelper.getApproxLocation();
    notifyListeners();
  }
}
