import 'dart:io';

import '../../../../data/model/api_response.dart';
import '../../../../interface/repo_interface.dart';
import '../models/profile_model.dart';

abstract class ProfileRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getProfileInfo(String userId);

  Future<ApiResponse> updateProfile(ProfileModel userInfoModel);

  Future<ApiResponse> updateAddress(Map<String, dynamic> updateAddressMap);

  Future<ApiResponse> setPassword(Map<String, dynamic> setPasswordMap);

  Future<ApiResponse> updatePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
}
