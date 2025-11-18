import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;
  OrderRepositoryImpl(this.remote);

  @override
  Future<List<Order>> getAll() async {
    return await remote.getAll();
  }

  @override
  Future<bool> updateStatus({required int orderId, required int statusId}) async {
    return await remote.updateStatus(orderId: orderId, statusId: statusId);
  }
}




