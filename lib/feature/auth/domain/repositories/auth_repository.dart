import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../data/datasource/remote/exception/api_error_handler.dart';
import '../../../../data/model/api_response.dart';
import '../../../../utils/app_constants.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepoInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepository({required this.dioClient, required this.sharedPreferences});

  // @override
  // Future<ApiResponse> registration(Map<String, dynamic> register) async {
  //   try {
  //     Response response =
  //         await dioClient!.post(AppConstants.registrationUri, data: register);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  @override
  Future<ApiResponse> login(String? userInput) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"contact_no": userInput},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> loginWithPassword(
    String? userInput,
    String? password,
  ) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginWithPasswordUri,
        data: {"contact_no": userInput, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> checkLoginWithPassEligibility(String? userInput) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.checkLoginWithPassEligibilityUri,
        data: {"contact_no": userInput},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // @override
  // Future<ApiResponse> logout() async {
  //   try {
  //     Response response = await dioClient!.get(AppConstants.logOut);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  @override
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(token);
    try {
      await sharedPreferences!.setString(AppConstants.userLoginToken, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.userLoginToken) ?? "";
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await sharedPreferences!.setString(AppConstants.userId, userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserId() {
    return sharedPreferences!.getString(AppConstants.userId) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.userLoginToken);
  }

  // @override
  // Future<ApiResponse> verifyOtp(String identity, String otp) async {
  //   try {
  //     Response response = await dioClient!.post(AppConstants.verifyOtpUri,
  //         data: {"phone": identity, "token": otp});
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  // @override
  // Future<ApiResponse> forgetPassword(String identity, String type) async {
  //   try {
  //     Response response = await dioClient!.post(AppConstants.forgetPasswordUri,
  //         data: {
  //           "email": identity
  //         } //{"email_or_phone": identity, "type": type},
  //         );
  //
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  // @override
  // Future<ApiResponse> verifyToken(String email, String token) async {
  //   try {
  //     Response response = await dioClient!.post(AppConstants.verifyTokenUri,
  //         data: {"email_or_phone": email, "reset_token": token});
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> forgetPassword(String identity, String yout) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> registration(Map<String, dynamic> body) {
    // TODO: implement registration
    throw UnimplementedError();
  }
  //
  // Future<String?> _getDeviceToken() async {
  //   String? deviceToken;
  //   if (Platform.isIOS) {
  //     deviceToken = await FirebaseMessaging.instance.getToken();
  //   } else {
  //     deviceToken = await FirebaseMessaging.instance.getToken();
  //   }
  //   if (deviceToken != null) {
  //     log('--------Device Token---------- $deviceToken--');
  //   }
  //   return deviceToken;
  // }
  //
  // Future<ApiResponse> updateDeviceToken() async {
  //   try {
  //     String? deviceToken = await _getDeviceToken();
  //     Response response = await dioClient!.post(
  //       AppConstants.tokenUri,
  //       data: {
  //         "_method": "put",
  //         'guest_id': Provider.of<AuthController>(
  //           Get.context!,
  //           listen: false,
  //         ).getGuestToken(),
  //         "cm_firebase_token": deviceToken,
  //       },
  //     );
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  @override
  Future<ApiResponse> verifyOtp(String userId, String otp) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.verifyOtpUri,
        data: {"user_id": userId, "otp": otp},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> verifyToken(String email, String token) {
    // TODO: implement verifyToken
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> updateDeviceToken(String token) async {
    try {
      dioClient?.updateHeader(token);

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'message': 'Header updated successfully'},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

}
