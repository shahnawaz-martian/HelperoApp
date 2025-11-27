class LoginModel {
  bool? status;
  int? code;
  String? message;
  User? user;

  LoginModel({this.status, this.code, this.message, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    user = json['data'] != null ? User.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (user != null) {
      data['data'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? otp;
  String? token;

  User({this.userId, this.otp, this.token});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otp = json['otp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['otp'] = otp;
    data['token'] = token;
    return data;
  }
}
