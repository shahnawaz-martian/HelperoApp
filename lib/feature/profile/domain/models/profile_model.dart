import 'dart:io';

class Profile {
  bool? status;
  int? code;
  String? message;
  ProfileModel? data;

  Profile({this.status, this.code, this.message, this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ProfileModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;

  return 0.0;
}

class ProfileModel {
  String? sId;
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? contactNo;
  String? role;
  String? status;
  Audit? audit;
  File? profileImage;
  String? profileImageUrl;
  List<Addresses>? addresses;

  ProfileModel({
    this.sId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.contactNo,
    this.role,
    this.status,
    this.audit,
    this.profileImage,
    this.profileImageUrl,
    this.addresses,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    contactNo = json['contact_no'];
    role = json['role'];
    status = json['status'];
    audit = json['audit'] != null ? Audit.fromJson(json['audit']) : null;
    profileImageUrl = json['profile_image'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['contact_no'] = contactNo;
    data['role'] = role;
    data['status'] = status;
    data['profile_image'] = profileImageUrl;
    if (audit != null) {
      data['audit'] = audit!.toJson();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Audit {
  String? createdAt;
  String? updatedAt;

  Audit({this.createdAt, this.updatedAt});

  Audit.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Addresses {
  String? addressType;
  String? addressLine1;
  String? addressLine2;
  String? blockNo;
  String? city;
  String? state;
  String? pinCode;
  double? distance;

  Addresses({
    this.addressType,
    this.addressLine1,
    this.addressLine2,
    this.blockNo,
    this.city,
    this.state,
    this.pinCode,
    this.distance,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    addressType = json['address_type'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    blockNo = json['block_no'];
    city = json['city'];
    state = json['state'];
    pinCode = json['pin_code'];
    distance = _toDouble(json['distance']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address_type'] = addressType;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['block_no'] = blockNo;
    data['city'] = city;
    data['state'] = state;
    data['pin_code'] = pinCode;
    data['distance'] = distance;
    return data;
  }
}
