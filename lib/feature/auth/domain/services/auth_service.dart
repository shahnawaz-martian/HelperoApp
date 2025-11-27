import '../repositories/auth_repository_interface.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  AuthRepoInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future forgetPassword(String identity, String type) {
    return authRepoInterface.forgetPassword(identity, type);
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  String getUserId() {
    return authRepoInterface.getUserId();
  }

  @override
  Future<void> saveUserId(String userId) {
    return authRepoInterface.saveUserId(userId);
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future login(String? userInput) {
    return authRepoInterface.login(userInput);
  }

  @override
  Future loginWithPassword(String? userInput, String? password) {
    return authRepoInterface.loginWithPassword(userInput, password);
  }

  @override
  Future checkLoginWithPassEligibility(String? userInput) {
    return authRepoInterface.checkLoginWithPassEligibility(userInput);
  }

  @override
  Future logout() {
    return authRepoInterface.logout();
  }

  @override
  Future registration(Map<String, dynamic> body) {
    return authRepoInterface.registration(body);
  }

  @override
  Future<void> saveUserToken(String token) {
    return authRepoInterface.saveUserToken(token);
  }

  @override
  Future updateDeviceToken(String token) {
    return authRepoInterface.updateDeviceToken(token);
  }

  @override
  Future verifyOtp(String otp, String identity) {
    return authRepoInterface.verifyOtp(otp, identity);
  }

  @override
  Future<bool> clearSharedData() {
    // TODO: implement clearSharedData
    throw UnimplementedError();
  }
}
