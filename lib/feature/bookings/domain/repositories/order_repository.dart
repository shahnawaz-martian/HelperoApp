import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:helpero/feature/bookings/domain/models/order_create_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../data/datasource/remote/exception/api_error_handler.dart';
import '../../../../data/model/api_response.dart';
import '../../../../utils/app_constants.dart';
import 'order_repository_interface.dart';

class OrderRepository implements OrderRepositoryInterface {
  final DioClient? dioClient;
  OrderRepository({required this.dioClient});

  @override
  Future<ApiResponse> getOrderList(Map<String, dynamic> body) async {
    try {
      final response = await dioClient!.post(
        AppConstants.getOrderList,
        data: body,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> orderDetails(String? orderId) async {
    try {
      final response = await dioClient!.get(
        "${AppConstants.getOrderDetailsUri}$orderId",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> orderCharges() async {
    try {
      final response = await dioClient!.post(
        AppConstants.getOrderChargesUri,
        data: {"from": 1, "size": 5, "searchText": ""},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> createOrder(OrderCreateRequest order) async {
    try {
      final response = await dioClient!.post(
        AppConstants.createOrderUri,
        data: order,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateOrder(
    OrderCreateRequest order,
    String orderId,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString(AppConstants.userLoginToken) ?? '';

    try {
      final Map<String, dynamic> data = {
        "order_id": orderId,
        "user_id": order.userId,
        "service": order.service,
        "order_type": order.orderType,
        "comment": order.comment,
        "subscription_duration_in_days": order.subscriptionDurationInDays,
        "date": (order.date?.isNotEmpty ?? false) ? order.date : "",
        "start_date": (order.startDate?.isNotEmpty ?? false)
            ? order.startDate
            : "",
        "end_date": (order.endDate?.isNotEmpty ?? false) ? order.endDate : "",
        "start_time": order.startTime,
        "service_charge": order.serviceCharge,
        "status": order.status,
        "is_delete": false,
        "duration": order.duration,
        "address_type": order.addressType,
        "address_line_1": order.addressLine1,
        "address_line_2": order.addressLine2,
        "block_no": order.blockNo,
        "city": order.city,
        "state": order.state,
        "pin_code": order.pinCode,
        "distance": order.distance,
        "quotation_id": "0",
      };

      print(jsonEncode(data));

      final response = await dioClient!.put(
        AppConstants.updateOrderUri,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (kDebugMode) {
        print("✅ Update Order Response: ${response.data}");
      }
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // @override
  // Future<ApiResponse> getTrackingInfo(String orderID) async {
  //   try {
  //     final response = await dioClient!.get(AppConstants.trackingUri + orderID);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
  //
  // @override
  // Future<ApiResponse> cancelOrder(int? orderId) async {
  //   try {
  //     final response = await dioClient!
  //         .get('${AppConstants.cancelOrderUri}?order_id=$orderId');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

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
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future cancelOrder(int? orderId) {
    // TODO: implement cancelOrder
    throw UnimplementedError();
  }

  @override
  Future getTrackingInfo(String orderID) {
    // TODO: implement getTrackingInfo
    throw UnimplementedError();
  }
}
