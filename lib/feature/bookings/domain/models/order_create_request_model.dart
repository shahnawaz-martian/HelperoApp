import '../../../profile/domain/models/profile_model.dart';

class OrderCreateResponse {
  final bool status;
  final int code;
  final String message;
  final String orderId;

  OrderCreateResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.orderId,
  });

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) {
    return OrderCreateResponse(
      status: json["status"],
      code: json["code"],
      message: json["message"],
      orderId: json["data"]["order_id"],
    );
  }
}

class OrderCreateRequest {
  final String userId;
  final String? orderId;
  final String? date;
  final String? service;
  final String? placeType;
  final String? orderType;
  final String? paymentStatus;
  final String? comment;
  final String? status;
  final int? subscriptionDurationInDays;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  double? serviceCharge;
  final String? duration;
  final String? distance;
  double? transportationCharge;

  final String? addressType;
  final String? addressLine1;
  final String? addressLine2;
  final String? blockNo;
  final String? city;
  final String? state;
  final String? pinCode;

  // full list of addresses
  List<Addresses>? addresses;

  OrderCreateRequest({
    required this.userId,
    this.orderId,
    this.date,
    this.service,
    this.placeType,
    this.orderType,
    this.paymentStatus,
    this.comment,
    this.status,
    this.subscriptionDurationInDays,
    this.startDate,
    this.endDate,
    this.startTime,
    this.serviceCharge,
    this.transportationCharge,
    this.duration,
    this.distance,

    this.addressType,
    this.addressLine1,
    this.addressLine2,
    this.blockNo,
    this.city,
    this.state,
    this.pinCode,

    this.addresses,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "order_id": orderId,
      "date": date,
      "service": service,
      "place_type": placeType,
      "order_type": orderType,
      "payment_status": paymentStatus,
      "comment": comment,
      "status": status,
      "subscription_duration_in_days": subscriptionDurationInDays,
      "start_date": startDate,
      "end_date": endDate,
      "start_time": startTime,
      "service_charge": serviceCharge,
      "duration": duration,
      "distance": distance,

      "address_type": addressType,
      "address_line_1": addressLine1,
      "address_line_2": addressLine2,
      "block_no": blockNo,
      "city": city,
      "state": state,
      "pin_code": pinCode,
      "transportation_charge": transportationCharge,

      if (addresses != null)
        "addresses": addresses!.map((e) => e.toJson()).toList(),
    };
  }
}
