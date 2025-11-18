import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getAll();
  Future<bool> updateStatus({required int orderId, required int statusId});
}




