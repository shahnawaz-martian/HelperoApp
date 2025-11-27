import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/bookings/domain/models/order_create_request_model.dart';
import 'package:helpero/feature/bookings/domain/models/order_detail_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/api_response.dart';
import '../../../data/model/response_model.dart';
import '../../../helper/api_checker.dart';
import '../../../main.dart';
import '../domain/models/order_charges_model.dart';
import '../domain/models/order_model.dart';
import '../domain/services/order_service_interface.dart';
import '../widget/booking_confirm_bottomsheet.dart';

class OrderController with ChangeNotifier {
  final OrderServiceInterface orderServiceInterface;
  OrderController({required this.orderServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialLoadDone = false;
  bool get isInitialLoadDone => _isInitialLoadDone;

  OrderDetailModel? orderDetailModel;
  List<Charges> chargesList = [];

  double lastScrollOffset = 0;

  int currentPage = 1;
  final int pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;

  Future<void> getOrderList(String? userId, {bool isRefresh = false}) async {
    if (_isLoading) return;

    if (isRefresh) {
      currentPage = 1;
      _hasMore = true;
      _orderList.clear();
    } else if (!_hasMore) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        "from": currentPage,
        "size": pageSize,
        "searchText": "",
        "filter": {"order_reference": "", "user_id": userId},
      };

      ApiResponse apiResponse = await orderServiceInterface.getOrderList(body);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final data = apiResponse.response!.data["data"];
        List jsonOrders = data["orders"] ?? [];
        int total = data["total_size"] ?? 0;

        final mappedOrders = jsonOrders
            .map((e) => OrderModel.fromJson(e))
            .toList();

        // _orderList.addAll(mappedOrders);
        if (isRefresh || currentPage == 1) {
          _orderList = mappedOrders;
        } else {
          _orderList.addAll(mappedOrders);
        }

        debugPrint(
          "✅ Loaded page $currentPage | total loaded ${_orderList.length}/$total",
        );

        // if (mappedOrders.isEmpty || _orderList.length >= total) {
        //   _hasMore = false;
        // } else {
        //   currentPage++;
        // }

        if (mappedOrders.length < pageSize) {
          _hasMore = false;
        } else {
          currentPage++;
        }
      }
    } catch (e) {
      debugPrint("Order fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderList(String? userId) async {
    if (userId == null) return;

    try {
      final body = {
        "from": 0,
        "size": pageSize,
        "searchText": "",
        "filter": {"order_reference": "", "user_id": userId},
      };

      ApiResponse apiResponse = await orderServiceInterface.getOrderList(body);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final data = apiResponse.response!.data["data"];
        List jsonOrders = data["orders"] ?? [];

        _orderList = jsonOrders.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Silent Order fetch error: $e");
    }
  }

  Future<ResponseModel> updateOrder(
    OrderCreateRequest order,
    String orderId,
  ) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await orderServiceInterface.updateOrder(order, orderId);

    _isLoading = false;
    notifyListeners();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      await getOrderList(order.userId);

      return ResponseModel(
        data["message"] ?? "Order updated successfully",
        true,
      );
    } else {
      final error = apiResponse.error;
      return ResponseModel(error ?? "Update failed", false);
    }
  }

  void updateOrderDetail(OrderDetailModel newData) {
    orderDetailModel = newData;
    notifyListeners();
  }

  Future<ApiResponse> getOrderDetails(
    String orderID, {
    bool isBackground = false,
  }) async {
    if (!isBackground) {
      _isLoading = true;
      notifyListeners();
    }

    ApiResponse apiResponse = await orderServiceInterface.orderDetails(orderID);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final orderDetailData = apiResponse.response?.data['data'];
      orderDetailModel = OrderDetailModel.fromJson(orderDetailData);

      // await getOrderList(
      //   Provider.of<AuthController>(Get.context!, listen: false).getUserId(),
      //   isRefresh: true,
      // );
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    if (!isBackground) {
      _isLoading = false;
      notifyListeners();
    } else {
      notifyListeners();
    }

    return apiResponse;
  }

  void updateStatus(String newStatus) {
    if (orderDetailModel != null) {
      orderDetailModel!.status = newStatus;
      notifyListeners();
    }
  }

  Future<ApiResponse> cancelOrder(BuildContext context, int? orderId) async {
    _isLoading = true;
    ApiResponse apiResponse = await orderServiceInterface.cancelOrder(orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ResponseModel> createOrder(OrderCreateRequest order) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await orderServiceInterface.createOrder(order);
    ResponseModel responseModel;

    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data;

      if (data['status'] == true && data['data'] != null) {
        responseModel = ResponseModel(
          data['message'] ?? 'Order created successfully!',
          true,
        );
        await getOrderList(
          Provider.of<AuthController>(Get.context!, listen: false).getUserId(),
        );
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          builder: (context) {
            return BookingConfirmBottomsheet(orderId: data['data']['order_id']);
          },
        );
      } else {
        responseModel = ResponseModel(
          data['message'] ?? 'Failed to create order',
          false,
        );
      }
    } else {
      responseModel = ResponseModel(
        apiResponse.error ?? 'Something went wrong',
        false,
      );
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> openDialer(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $phoneNumber');
    }
  }

  Future<void> openSMS(String phoneNumber, {String message = ''}) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message.isNotEmpty ? {'body': message} : null,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch SMS app';
    }
  }

  Future<void> getOrderCharges() async {
    ApiResponse apiResponse = await orderServiceInterface.orderCharges();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final data = apiResponse.response!.data["data"];

      List<dynamic> jsonCharges = data["serviceCharge"] ?? [];

      chargesList = jsonCharges.map((e) => Charges.fromJson(e)).toList();

      debugPrint("Charges Loaded: ${chargesList.length}");
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
}
