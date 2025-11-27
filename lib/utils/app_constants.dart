class AppConstants {
  static const String theme = 'theme';

  static const String baseUrl = 'https://helpero-api.onrender.com/api';
  //static const String baseUrl = 'http://192.168.1.10:5000/api';

  static const String loginUri = '/user/user-login';
  static const String loginWithPasswordUri = '/user/login-with-password';
  static const String checkLoginWithPassEligibilityUri =
      '/user/check-password-login-eligibility';
  static const String verifyOtpUri = '/user/verify-otp';
  static const String getProfileUri = '/user/get-user/';
  static const String updateProfileUri = '/user/update-user';
  static const String updatePasswordUri = '/user/update-user-password';
  static const String getOrderDetailsUri = '/order/get-order/';
  static const String getOrderList = '/order/order-list';
  static const String createOrderUri = '/order/create-order';
  static const String updateOrderUri = "/order/update-order";
  static const String getOrderChargesUri = "/serviceCharge/service-charge-list";

  static const String userLoginToken = 'user_login_token';
  static const String userId = 'user_id';
  static const String isVerified = 'isVerified';
  static const String configUri = "local_config";
  static const String distance = "distance";
}
