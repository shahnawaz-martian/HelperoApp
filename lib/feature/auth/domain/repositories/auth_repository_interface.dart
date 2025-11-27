import '../../../../data/model/api_response.dart';
import '../../../../interface/repo_interface.dart';

abstract class AuthRepoInterface<T> implements RepositoryInterface {
  Future<ApiResponse> registration(Map<String, dynamic> body);

  Future<ApiResponse> login(String? userInput);

  Future<ApiResponse> loginWithPassword(String? userInput,String? password);

  Future<ApiResponse> logout();

  Future<ApiResponse> updateDeviceToken(String token);

  String getUserToken();

  bool isLoggedIn();

  Future<void> saveUserToken(String token);

  Future<void> saveUserId(String userId);

  String getUserId();

  Future<ApiResponse> forgetPassword(String identity, String yout);

  Future<ApiResponse> verifyOtp(String otp, String identity);

  Future<ApiResponse> verifyToken(String email, String token);

  Future<ApiResponse> checkLoginWithPassEligibility(String? userInput);


}
