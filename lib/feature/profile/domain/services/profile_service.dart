import 'dart:io';

import 'package:helpero/data/model/api_response.dart';
import 'package:helpero/feature/profile/domain/services/profile_service_interface.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository_interface.dart';

class ProfileService implements ProfileServiceInterface {
  ProfileRepositoryInterface profileRepositoryInterface;

  ProfileService({required this.profileRepositoryInterface});

  @override
  Future<ApiResponse> getProfileInfo(String userId) async {
    return await profileRepositoryInterface.getProfileInfo(userId);
  }

  @override
  Future<ApiResponse> updateProfile(ProfileModel userInfoModel) async {
    return await profileRepositoryInterface.updateProfile(userInfoModel);
  }

  @override
  Future<ApiResponse> updateAddress(
    Map<String, dynamic> updateAddressMap,
  ) async {
    return await profileRepositoryInterface.updateAddress(updateAddressMap);
  }

  @override
  Future<ApiResponse> setPassword(Map<String, dynamic> setPasswordMap) async {
    return await profileRepositoryInterface.setPassword(setPasswordMap);
  }

  @override
  Future updatePassword(String userId, String oldPassword, String newPassword) {
    return profileRepositoryInterface.updatePassword(
      userId,
      oldPassword,
      newPassword,
    );
  }
}
