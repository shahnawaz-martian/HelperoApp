import 'dart:developer';

import '../base_widget/show_custom_snakbar_widget.dart';
import '../data/model/api_response.dart';
import '../data/model/error_response.dart';
import '../feature/auth/controllers/auth_controller.dart';
import '../main.dart';

class ApiChecker {
  static void checkApi(
    ApiResponse apiResponse, {
    bool firebaseResponse = false,
  }) {
    // dynamic errorResponse = apiResponse.error is String
    //     ? apiResponse.error
    //     : ErrorResponse.fromJson(apiResponse.error);
    dynamic errorResponse = apiResponse.error is String
        ? apiResponse.error
        : apiResponse.error is ErrorResponse
        ? apiResponse.error
        : (apiResponse.error is Map<String, dynamic>
              ? ErrorResponse.fromJson(apiResponse.error)
              : null);
    if (apiResponse.error == "Failed to load data - status code: 401") {
      // Provider.of<AuthController>(
      //   Get.context!,
      //   listen: false,
      // ).clearSharedData();
    } else if (apiResponse.response?.statusCode == 422) {
      final message =
          apiResponse.response?.data['message'] ?? 'Something went wrong.';
      showCustomSnackBar(message, Get.context!);
    } else if (apiResponse.response?.statusCode == 500) {
      showCustomSnackBar('internal_server_error', Get.context!);
    } else if (apiResponse.response?.statusCode == 503) {
      showCustomSnackBar(apiResponse.response?.data['message'], Get.context!);
    } else {
      log("==ff=>${apiResponse.error}");
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = errorResponse.errors?[0].message;
        log("$errorMessage");
      }
      showCustomSnackBar(
        firebaseResponse ? errorResponse?.replaceAll('_', ' ') : errorMessage,
        Get.context!,
      );
    }
  }

  static ErrorResponse getError(ApiResponse apiResponse) {
    ErrorResponse error;

    try {
      error = ErrorResponse.fromJson(apiResponse.response?.data);
    } catch (e) {
      if (apiResponse.error is String) {
        error = ErrorResponse(
          errors: [Errors(code: '', message: apiResponse.error.toString())],
        );
      } else {
        error = ErrorResponse.fromJson(apiResponse.error);
      }
    }
    return error;
  }
}
