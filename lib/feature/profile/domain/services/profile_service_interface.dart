import 'dart:io';

import 'package:helpero/data/model/api_response.dart';

import '../models/profile_model.dart';

abstract class ProfileServiceInterface {
  Future<dynamic> getProfileInfo(String userId);

  Future<dynamic> updateProfile(ProfileModel userInfoModel);

  Future<dynamic> updateAddress(Map<String, dynamic> updateAddressMap);

  Future<dynamic> setPassword(Map<String, dynamic> setPasswordMap);

  Future<dynamic> updatePassword(String userId, String oldPassword, String newPassword);
}
