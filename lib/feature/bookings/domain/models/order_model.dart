import 'order_detail_model.dart';

class Data {
  int? totalSize;
  int? totalNoOfOrderHelper;
  int? totalNoOfCustomer;
  List<OrderModel>? orders;

  Data({
    this.totalSize,
    this.totalNoOfOrderHelper,
    this.totalNoOfCustomer,
    this.orders,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    totalNoOfOrderHelper = json['totalNoOfOrderHelper'];
    totalNoOfCustomer = json['totalNoOfCustomer'];
    if (json['orders'] != null) {
      orders = <OrderModel>[];
      json['orders'].forEach((v) {
        orders!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['totalNoOfOrderHelper'] = totalNoOfOrderHelper;
    data['totalNoOfCustomer'] = totalNoOfCustomer;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
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

class OrderModel {
  String? sId;
  String? orderId;
  String? quotationId;
  String? userId;
  String? helperId;
  String? date;
  String? service;
  String? placeType;
  String? orderType;
  double? amount;
  String? paymentMode;
  String? paymentStatus;
  String? renewalDate;
  String? comment;
  Audit? audit;
  String? status;
  String? orderReference;
  int? subscriptionDurationInDays;
  String? startDate;
  String? endDate;
  bool? isDelete;
  String? startTime;
  double? serviceCharge;
  double? transportationCharge;
  String? distance;
  String? duration;
  String? addressType;
  String? addressLine1;
  String? addressLine2;
  String? blockNo;
  String? houseNo;
  String? city;
  String? state;
  UserDetails? userDetails;
  HelperDetails? helperDetails;
  String? pinCode;

  OrderModel({
    this.sId,
    this.orderId,
    this.quotationId,
    this.userId,
    this.helperId,
    this.date,
    this.service,
    this.placeType,
    this.orderType,
    this.amount,
    this.paymentMode,
    this.paymentStatus,
    this.renewalDate,
    this.comment,
    this.audit,
    this.status,
    this.orderReference,
    this.subscriptionDurationInDays,
    this.startDate,
    this.endDate,
    this.isDelete,
    this.startTime,
    this.serviceCharge,
    this.transportationCharge,
    this.distance,
    this.duration,
    this.addressType,
    this.addressLine1,
    this.addressLine2,
    this.blockNo,
    this.houseNo,
    this.city,
    this.state,
    this.userDetails,
    this.helperDetails,
    this.pinCode,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['order_id'];
    quotationId = json['quotation_id'];
    userId = json['user_id'];
    helperId = json['helper_id'];
    date = json['date'];
    service = json['service'];
    placeType = json['place_type'];
    orderType = json['order_type'];
    paymentMode = json['payment_mode'];
    paymentStatus = json['payment_status'];
    renewalDate = json['renewal_date'];
    comment = json['comment'];
    audit = json['audit'] != null ? Audit.fromJson(json['audit']) : null;
    status = json['status'];
    orderReference = json['order_reference'];
    subscriptionDurationInDays = json['subscription_duration_in_days'] is num
        ? (json['subscription_duration_in_days'] as num).toInt()
        : int.tryParse(json['subscription_duration_in_days']?.toString() ?? "");

    startDate = json['start_date'];
    endDate = json['end_date'];
    isDelete = json['is_delete'];
    startTime = json['start_time'];
    amount = _toDouble(json['amount']);
    serviceCharge = _toDouble(json['service_charge']);
    transportationCharge = _toDouble(json['transportation_charge']);
    distance = json['distance']?.toString();
    duration = json['duration']?.toString();
    addressType = json['address_type'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    blockNo = json['block_no'];
    houseNo = json['house_no'];
    city = json['city'];
    state = json['state'];
    pinCode = json['pin_code'];
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
    helperDetails = json['helperDetails'] != null
        ? HelperDetails.fromJson(json['helperDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['order_id'] = orderId;
    data['quotation_id'] = quotationId;
    data['user_id'] = userId;
    data['helper_id'] = helperId;
    data['date'] = date;
    data['service'] = service;
    data['place_type'] = placeType;
    data['order_type'] = orderType;
    data['amount'] = amount;
    data['payment_mode'] = paymentMode;
    data['payment_status'] = paymentStatus;
    data['renewal_date'] = renewalDate;
    data['comment'] = comment;
    if (audit != null) {
      data['audit'] = audit!.toJson();
    }
    data['status'] = status;
    data['order_reference'] = orderReference;
    data['subscription_duration_in_days'] = subscriptionDurationInDays;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['is_delete'] = isDelete;
    data['start_time'] = startTime;
    data['service_charge'] = serviceCharge;
    data['transportation_charge'] = transportationCharge;
    data['distance'] = distance;
    data['duration'] = duration;
    data['address_type'] = addressType;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['block_no'] = blockNo;
    data['house_no'] = houseNo;
    data['city'] = city;
    data['state'] = state;
    data['pin_code'] = pinCode;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    if (helperDetails != null) {
      data['helperDetails'] = helperDetails!.toJson();
    }
    return data;
  }
}

class Audit {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;

  Audit({this.createdAt, this.updatedAt, this.createdBy, this.updatedBy});

  Audit.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}

class UserDetails {
  String? sId;
  String? userId;
  String? firstName;
  String? lastName;
  String? city;
  String? pinCode;
  String? addressLine1;
  String? addressLine2;
  String? state;
  String? email;
  String? password;
  String? contactNo;
  String? role;
  String? status;
  Audit? audit;
  String? otp;
  String? profileImage;

  UserDetails({
    this.sId,
    this.userId,
    this.firstName,
    this.lastName,
    this.city,
    this.pinCode,
    this.addressLine1,
    this.addressLine2,
    this.state,
    this.email,
    this.password,
    this.contactNo,
    this.role,
    this.status,
    this.audit,
    this.otp,
    this.profileImage,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    city = json['city'];
    pinCode = json['pin_code'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    state = json['state'];
    email = json['email'];
    password = json['password'];
    contactNo = json['contact_no'];
    role = json['role'];
    status = json['status'];
    audit = json['audit'] != null ? Audit.fromJson(json['audit']) : null;
    otp = json['otp'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['city'] = city;
    data['pin_code'] = pinCode;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['state'] = state;
    data['email'] = email;
    data['password'] = password;
    data['contact_no'] = contactNo;
    data['role'] = role;
    data['status'] = status;
    if (audit != null) data['audit'] = audit!.toJson();
    data['otp'] = otp;
    data['profile_image'] = profileImage;
    return data;
  }
}
