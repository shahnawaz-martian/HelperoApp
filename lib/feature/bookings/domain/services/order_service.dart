import 'package:helpero/feature/bookings/domain/models/order_create_request_model.dart';

import '../repositories/order_repository_interface.dart';
import 'order_service_interface.dart';

class OrderService implements OrderServiceInterface {
  OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future cancelOrder(int? orderId) async {
    return await orderRepositoryInterface.cancelOrder(orderId);
  }

  @override
  Future<void> getOrderList(Map<String, dynamic> body) async {
    return await orderRepositoryInterface.getOrderList(body);
  }

  @override
  Future getTrackingInfo(String orderID) async {
    return await orderRepositoryInterface.getTrackingInfo(orderID);
  }

  @override
  Future orderDetails(String orderID) async {
    return await orderRepositoryInterface.orderDetails(orderID);
  }

  @override
  Future orderCharges() async {
    return await orderRepositoryInterface.orderCharges();
  }

  @override
  Future createOrder(OrderCreateRequest order) async {
    return await orderRepositoryInterface.createOrder(order);
  }

  @override
  Future updateOrder(
    OrderCreateRequest order,
    String orderId,
  ) async {
    return await orderRepositoryInterface.updateOrder(
      order,
      orderId,
    );
  }
}
