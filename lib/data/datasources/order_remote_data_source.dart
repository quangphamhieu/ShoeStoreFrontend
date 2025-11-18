import '../../core/constants/api_endpoint.dart';
import '../../core/network/api_client.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final ApiClient client;
  OrderRemoteDataSource(this.client);

  Future<List<OrderModel>> getAll() async {
    final response = await client.get(ApiEndpoint.orders);
    final data = response.data;
    if (data is List) {
      return data.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<bool> updateStatus({required int orderId, required int statusId}) async {
    final body = {
      'orderId': orderId,
      'statusId': statusId,
    };
    final response = await client.put('${ApiEndpoint.orders}/status', body);
    final successCodes = {200, 204};
    return successCodes.contains(response.statusCode);
  }
}




