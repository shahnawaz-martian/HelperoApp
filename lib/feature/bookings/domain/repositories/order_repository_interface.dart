import 'package:helpero/feature/bookings/domain/models/order_create_request_model.dart';

import '../../../../interface/repo_interface.dart';

abstract class OrderRepositoryInterface<T> extends RepositoryInterface {
  Future<void> getOrderList(Map<String, dynamic> body);

  Future<dynamic> getTrackingInfo(String orderID);

  Future<dynamic> orderDetails(String orderID);

  Future<dynamic> orderCharges();

  Future<dynamic> cancelOrder(int? orderId);

  Future<dynamic> createOrder(OrderCreateRequest order);

  Future<dynamic> updateOrder(OrderCreateRequest order, String orderId);
}
