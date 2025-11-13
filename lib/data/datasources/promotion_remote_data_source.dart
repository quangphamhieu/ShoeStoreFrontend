import '../../core/constants/api_endpoint.dart';
import '../../core/network/api_client.dart';
import '../models/promotion_model.dart';

class PromotionRemoteDataSource {
  final ApiClient client;
  PromotionRemoteDataSource(this.client);

  Future<List<PromotionModel>> getAll() async {
    final response = await client.get(ApiEndpoint.promotions);
    final data = response.data;
    if (data is List) {
      return data.map((e) => PromotionModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<PromotionModel?> getById(int id) async {
    final response = await client.get('${ApiEndpoint.promotions}/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return PromotionModel.fromJson(data);
    }
    return null;
  }

  Future<PromotionModel> create(PromotionModel promotion) async {
    final response = await client.post(ApiEndpoint.promotions, promotion.toCreateJson());
    return PromotionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PromotionModel?> update(int id, PromotionModel promotion) async {
    final response = await client.put('${ApiEndpoint.promotions}/$id', promotion.toUpdateJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return PromotionModel.fromJson(data);
    }
    return null;
  }

  Future<bool> delete(int id) async {
    final response = await client.delete('${ApiEndpoint.promotions}/$id');
    return response.statusCode == 204 || response.statusCode == 200;
  }
}

