import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/main.dart';
import 'package:helpero/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base_widget/show_custom_snakbar_widget.dart';
import '../../../data/local/cache_response.dart';
import '../../../data/model/api_response.dart';
import '../../../data/model/response_model.dart';
import '../../../helper/api_checker.dart';
import '../domain/model/config_model.dart';
import '../domain/services/auth_service_interface.dart';
import '../view/set_password/view/set_password.dart';
import '../widget/otp_veridication_dialog.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;

  AuthController({required this.authServiceInterface});

  bool isLoading = false;
  set setIsLoading(bool value) => isLoading = value;

  bool isVerified = false;
  set setIsVerified(bool value) => isVerified = value;

  String? _loginErrorMessage = '';
  String? get loginErrorMessage => _loginErrorMessage;

  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  set setForgetPasswordLoading(bool value) => _isForgotPasswordLoading = value;

  String? userID;
  String? get userId => userID;

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  Future<ResponseModel> login(
    String? userInput, {
    bool isFromForgetPassword = false,
  }) async {
    isFromForgetPassword ? isLoading = false : isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await authServiceInterface.login(userInput);
    ResponseModel responseModel;

    isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      if (data['status'] == true && data['data'] != null) {
        final token = data['data']['token'];
        final otp = data['data']['otp'];
        final id = data['data']['user_id'];

        if (token != null && token.isNotEmpty) {
          // await authServiceInterface.saveUserToken(token);

          await authServiceInterface.saveUserId(id);

          await authServiceInterface.updateDeviceToken(token);

          userID = id?.toString();
          notifyListeners();

          if (kDebugMode) {
            print("✅ User token saved: $token");
            print("✅ User ID: $userId");
          }
        }

        if (otp != null && otp.isNotEmpty) {
          if (kDebugMode) {
            print(" User OTP: $otp");
          }

          showCustomSnackBar(data['data']['otp'], Get.context!, isError: false);
          showDialog(
            context: Get.context!,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: OtpVerificationDialog(
                  phoneNumber: userInput.toString(),
                  userId: userID!,
                  isFromForgotPassword: isFromForgetPassword,
                  token: data['data']['token'],
                ),
              );
            },
          );
        }

        responseModel = ResponseModel(
          data['message'] ?? 'Login successful',
          true,
        );
      } else {
        responseModel = ResponseModel(data['message'] ?? 'Login failed', false);
      }
    } else {
      responseModel = ResponseModel(
        apiResponse.error ?? 'Something went wrong',
        false,
      );
      ApiChecker.checkApi(apiResponse);
    }

    isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<bool> checkLoginWithPassEligibility(String? userInput) async {
    try {
      final apiResponse = await authServiceInterface
          .checkLoginWithPassEligibility(userInput);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final data = apiResponse.response!.data;

        if (data['status'] == true &&
            data['data'] != null &&
            data['code'] == 200) {
          final bool eligible = data['data']['eligible'] ?? false;
          if (kDebugMode) print("✅ Eligible: $eligible");

          return eligible;
        } else if (data['status'] == false && data['code'] == 404) {
          showCustomSnackBar(data['message'], Get.context!);
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) print("❌ Error checking eligibility: $e");
      return false;
    }
  }

  Future<ResponseModel> loginWithPassword(
    String? userInput,
    String? password,
  ) async {
    isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await authServiceInterface.loginWithPassword(
      userInput,
      password,
    );
    ResponseModel responseModel;

    isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      if (data['status'] == true && data['data'] != null) {
        final token = data['data']['token'];
        final id = data['data']['user_id'];

        if (token != null && token.isNotEmpty) {
          await authServiceInterface.saveUserToken(token);

          await authServiceInterface.saveUserId(id);

          await authServiceInterface.updateDeviceToken(token);

          userID = id?.toString();
          notifyListeners();

          if (kDebugMode) {
            print("✅ User token saved: $token");
            print("✅ User ID: $userId");
          }
        }

        // if (otp != null && otp.isNotEmpty) {
        //   if (kDebugMode) {
        //     print(" User OTP: $otp");
        //   }
        //   showDialog(
        //     context: Get.context!,
        //     builder: (context) {
        //       return Dialog(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: OtpVerificationDialog(
        //           phoneNumber: userInput.toString(),
        //           userId: userID!,
        //         ),
        //       );
        //     },
        //   );
        // }

        responseModel = ResponseModel(
          data['message'] ?? 'Login successful',
          true,
        );

        showCustomSnackBar(data["message"], Get.context!, isError: false);

        await Future.delayed(const Duration(milliseconds: 800));

        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
        );
      } else {
        responseModel = ResponseModel(data['message'] ?? 'Login failed', false);

        showCustomSnackBar(data["message"], Get.context!);
      }
    } else {
      responseModel = ResponseModel(
        apiResponse.error ?? 'Something went wrong',
        false,
      );

      showCustomSnackBar(apiResponse.error, Get.context!);
      ApiChecker.checkApi(apiResponse);
    }

    isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyOtp(
    String userId,
    String otp,
    String token, {
    bool isFromForgetPassword = false,
  }) async {
    isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await authServiceInterface.verifyOtp(userId, otp);
    ResponseModel responseModel;

    isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseData = apiResponse.response!.data;

      if (responseData["status"] == true) {
        log("✅ OTP verified successfully for user: $userId");

        await authServiceInterface.saveUserToken(token);

        await authServiceInterface.updateDeviceToken(token);

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        isFromForgetPassword
            ? sharedPreferences.setBool(AppConstants.isVerified, false)
            : sharedPreferences.setBool(AppConstants.isVerified, true);

        showCustomSnackBar(
          responseData["message"],
          Get.context!,
          isError: false,
        );

        await Future.delayed(const Duration(milliseconds: 800));

        responseModel = ResponseModel(responseData["message"], true);
      } else {
        responseModel = ResponseModel(responseData["message"], false);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
      responseModel = ResponseModel(apiResponse.error, false);
    }

    isLoading = false;
    notifyListeners();
    return responseModel;
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String getUserId() {
    return authServiceInterface.getUserId();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  bool _firstTimeConnectionCheck = true;

  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  Future<void> initConfig(BuildContext context) async {
    try {
      final configLocalData = await database.getCacheResponseById(
        AppConstants.configUri,
      );

      if (configLocalData != null) {
        _configModel = ConfigModel.fromJson(
          jsonDecode(configLocalData.response),
        );

        debugPrint("✅ Loaded config from local cache");
        debugPrint("📦 Config data: ${_configModel?.toJson()}");
      } else {
        _configModel = ConfigModel(hasLocaldb: true);

        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.configUri),
            header: const Value("{}"),
            response: Value(jsonEncode(_configModel!.toJson())),
          ),
        );

        debugPrint("✅ Default config saved locally");
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error loading config: $e");
      showCustomSnackBar("Failed to load configuration", Get.context!);
    }
  }
}
