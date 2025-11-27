import '../models/order_create_request_model.dart';

abstract class OrderServiceInterface {
  Future<dynamic> getOrderList(Map<String, dynamic> body);

  Future<dynamic> getTrackingInfo(String orderID);

  Future<dynamic> orderDetails(String orderID);

  Future<dynamic> orderCharges();

  Future<dynamic> cancelOrder(int? orderId);

  Future<dynamic> createOrder(OrderCreateRequest order);

  Future<dynamic> updateOrder(OrderCreateRequest order, String orderId);
}
