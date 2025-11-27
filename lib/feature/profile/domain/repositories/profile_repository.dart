import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/profile/domain/repositories/profile_repository_interface.dart';
import 'package:helpero/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../data/datasource/remote/exception/api_error_handler.dart';
import '../../../../data/model/api_response.dart';
import '../../../../utils/app_constants.dart';
import '../models/profile_model.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponse> getProfileInfo(String userId) async {
    try {
      final response = await dioClient!.get(
        "${AppConstants.getProfileUri}$userId",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateProfile(ProfileModel userInfoModel) async {
    String token = Provider.of<AuthController>(
      Get.context!,
      listen: false,
    ).getUserToken();

    String? addressesJson;
    if (userInfoModel.addresses != null &&
        userInfoModel.addresses!.isNotEmpty) {
      addressesJson = jsonEncode(
        userInfoModel.addresses!.map((a) => a.toJson()).toList(),
      );
    }

    try {
      FormData formData = FormData.fromMap({
        'user_id': userInfoModel.userId,
        'first_name': userInfoModel.firstName,
        'last_name': userInfoModel.lastName,
        'email': userInfoModel.email,
        'password': userInfoModel.password,
        'contact_no': userInfoModel.contactNo,

        if (userInfoModel.profileImage != null)
          "profileImage": await MultipartFile.fromFile(
            userInfoModel.profileImage!.path,
            filename: userInfoModel.profileImage!.path.split('/').last,
          ),

        if (addressesJson != null) 'addresses': addressesJson,
      });

      final response = await dioClient!.put(
        AppConstants.updateProfileUri,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (kDebugMode) {
        print("✅ Update Profile Response: ${response.data}");
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error updating profile: $e");
      }
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateAddress(
    Map<String, dynamic> updateAddressMap,
  ) async {
    String token = Provider.of<AuthController>(
      Get.context!,
      listen: false,
    ).getUserToken();

    String addressesJson = jsonEncode(updateAddressMap['addresses']);

    FormData formData = FormData.fromMap({
      'user_id': updateAddressMap['user_id'],
      'contact_no': updateAddressMap['contact_no'],
      'addresses': addressesJson,
    });

    try {
      final response = await dioClient!.put(
        AppConstants.updateProfileUri,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> setPassword(
    Map<String, dynamic> updatePasswordMap,
  ) async {
    String token = Provider.of<AuthController>(
      Get.context!,
      listen: false,
    ).getUserToken();

    FormData formData = FormData.fromMap({
      'user_id': updatePasswordMap['user_id'],
      'contact_no': updatePasswordMap['contact_no'],
      'password': updatePasswordMap['password'],
    });

    try {
      final response = await dioClient!.put(
        AppConstants.updateProfileUri,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updatePassword(
    String? userId,
    String? oldPassword,
    String? newPassword,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.userLoginToken);

    try {
      Response response = await dioClient!.put(
        AppConstants.updatePasswordUri,
        data: {
          "user_id": userId,
          "old_password": oldPassword,
          "new_password": newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
