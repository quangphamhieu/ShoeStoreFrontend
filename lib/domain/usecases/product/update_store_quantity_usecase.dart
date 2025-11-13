import '../../entities/store_quantity.dart';
import '../../repositories/product_repository.dart';

class UpdateStoreQuantityUseCase {
  final ProductRepository repository;
  UpdateStoreQuantityUseCase(this.repository);

  Future<StoreQuantity?> call(int productId, int storeId, int quantity, {String? storeName}) =>
      repository.updateStoreQuantity(productId, storeId, quantity, storeName: storeName);
}

