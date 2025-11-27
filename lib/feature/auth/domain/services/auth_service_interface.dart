abstract class AuthServiceInterface {
  Future<dynamic> registration(Map<String, dynamic> body);

  Future<dynamic> login(String? userInput);

  Future<dynamic> loginWithPassword(String? userInput, String? password);

  Future<dynamic> logout();

  Future<dynamic> updateDeviceToken(String token);

  String getUserToken();

  bool isLoggedIn();

  Future<bool> clearSharedData();

  Future<void> saveUserToken(String token);

  Future<void> saveUserId(String userId);

  String getUserId();

  Future<dynamic> forgetPassword(String identity, String type);

  Future<dynamic> verifyOtp(String otp, String identity);

  Future<dynamic> checkLoginWithPassEligibility(String? userInput);


}
