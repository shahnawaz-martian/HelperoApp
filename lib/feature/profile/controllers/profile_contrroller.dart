import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/main.dart';

import '../../../data/local/cache_response.dart';
import '../../../data/model/api_response.dart';
import '../../../data/model/response_model.dart';
import '../../../helper/api_checker.dart';
import '../../../utils/app_constants.dart';
import '../domain/models/profile_model.dart';
import '../domain/services/profile_service_interface.dart';

class ProfileController extends ChangeNotifier {
  final ProfileServiceInterface? profileServiceInterface;

  ProfileController({required this.profileServiceInterface});

  ProfileModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;

  bool get isDeleting => _isDeleting;

  ProfileModel? get userInfoModel => _userInfoModel;

  bool get isLoading => _isLoading;
  Addresses? selectedAddress;

  void setSelectedAddress(Addresses address) {
    selectedAddress = address;
    notifyListeners();
  }

  Future<void> getUserInfo(BuildContext context, String userId) async {
    var cacheKey = "${AppConstants.getProfileUri}/$userId";
    var cachedData = await database.getCacheResponseById(cacheKey);

    if (cachedData != null) {
      try {
        final cachedJson = jsonDecode(cachedData.response);
        _userInfoModel = ProfileModel.fromJson(cachedJson);
        // debugPrint("✅ Loaded user profile from local cache");
        notifyListeners();
      } catch (e) {
        // debugPrint("⚠️ Failed to parse cached user profile: $e");
      }
    }

    ApiResponse apiResponse = await profileServiceInterface!.getProfileInfo(
      userId,
    );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data["status"] == true) {
      final responseData = apiResponse.response!.data["data"];
      _userInfoModel = ProfileModel.fromJson(responseData);

      try {
        if (cachedData != null) {
          await database.updateCacheResponse(
            cacheKey,
            CacheResponseCompanion(
              endPoint: Value(cacheKey),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(responseData)),
            ),
          );
        } else {
          await database.insertCacheResponse(
            CacheResponseCompanion(
              endPoint: Value(cacheKey),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(responseData)),
            ),
          );
        }

        debugPrint("💾 Saved user profile to local cache");
      } catch (e) {
        debugPrint("⚠️ Failed to save user profile in cache: $e");
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(ProfileModel updateUserModel) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await profileServiceInterface!.updateProfile(
      updateUserModel,
    );

    _isLoading = false;
    notifyListeners();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;
      _userInfoModel = updateUserModel;

      showCustomSnackBar(data["message"], Get.context!, isError: false);
      await getUserInfo(Get.context!, updateUserModel.userId!);
      Navigator.of(Get.context!).push(
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarScreen(initialIndex: 2),
        ),
      );
      return ResponseModel(
        data["message"] ?? "Profile updated successfully",
        true,
      );
    } else {
      final error = apiResponse.error;
      showCustomSnackBar(error, Get.context!, isError: true);
      return ResponseModel(error ?? "Update failed", false);
    }
  }

  Future<ResponseModel> updateUserAddress(
    Map<String, dynamic> updateAddressMap,
  ) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await profileServiceInterface!.updateAddress(
      updateAddressMap,
    );

    _isLoading = false;
    notifyListeners();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userInfoModel?.addresses = (updateAddressMap['addresses'] as List)
          .map((e) => Addresses.fromJson(e))
          .toList();
      notifyListeners();

      return ResponseModel(
        apiResponse.response!.data["message"] ?? "Address updated successfully",
        true,
      );
    } else {
      final error = apiResponse.error;
      showCustomSnackBar(error, Get.context!, isError: true);
      return ResponseModel(error ?? "Update failed", false);
    }
  }

  Future<ResponseModel> setPassword(Map<String, dynamic> setPasswordMap) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await profileServiceInterface!.setPassword(
      setPasswordMap,
    );

    _isLoading = false;
    notifyListeners();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      showCustomSnackBar(
        "Password set successfully",
        Get.context!,
        isError: false,
      );
      return ResponseModel(
        data["message"] ?? "Password set successfully",
        true,
      );
    } else {
      final error = apiResponse.error;
      showCustomSnackBar(
        "Unable to set password. Please try again.",
        Get.context!,
        isError: true,
      );
      return ResponseModel(
        error ?? "Unable to set password. Please try again.",
        false,
      );
    }
  }

  Future<ResponseModel> updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await profileServiceInterface!.updatePassword(
      userId,
      oldPassword,
      newPassword,
    );

    _isLoading = false;
    notifyListeners();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      showCustomSnackBar(data["message"], Get.context!, isError: false);
      return ResponseModel(
        data["message"] ?? "Password updated successfully",
        true,
      );
    } else {
      final error = apiResponse.error;
      showCustomSnackBar(error, Get.context!, isError: true);
      return ResponseModel(error ?? "Update failed", false);
    }
  }

  // void clearProfileData() {
  //   _userInfoModel = null;
  //   notifyListeners();
  //}
}
