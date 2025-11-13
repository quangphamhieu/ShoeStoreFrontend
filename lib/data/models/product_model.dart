import '../../domain/entities/product.dart';
import '../../domain/entities/store_quantity.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    String? sku,
    required String name,
    int? brandId,
    int? supplierId,
    required double costPrice,
    required double originalPrice,
    String? color,
    String? size,
    String? description,
    String? imageUrl,
    required int statusId,
    required DateTime createdAt,
    List<StoreQuantity> stores = const [],
  }) : super(
          id: id,
          sku: sku,
          name: name,
          brandId: brandId,
          supplierId: supplierId,
          costPrice: costPrice,
          originalPrice: originalPrice,
          color: color,
          size: size,
          description: description,
          imageUrl: imageUrl,
          statusId: statusId,
          createdAt: createdAt,
          stores: stores,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final storesJson = json['stores'] as List<dynamic>?;
    final stores = storesJson?.map((s) => StoreQuantityModel.fromJson(s as Map<String, dynamic>)).toList() ?? [];

    return ProductModel(
      id: json['id'] as int,
      sku: json['sku'] as String?,
      name: json['name'] as String,
      brandId: json['brandId'] as int?,
      supplierId: json['supplierId'] as int?,
      costPrice: (json['costPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      color: json['color'] as String?,
      size: json['size'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      statusId: json['statusId'] as int? ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      stores: stores,
    );
  }
}

class StoreQuantityModel extends StoreQuantity {
  StoreQuantityModel({
    required int storeId,
    required String storeName,
    required int quantity,
    required double salePrice,
  }) : super(storeId: storeId, storeName: storeName, quantity: quantity, salePrice: salePrice);

  factory StoreQuantityModel.fromJson(Map<String, dynamic> json) => StoreQuantityModel(
        storeId: json['storeId'] as int,
        storeName: json['storeName'] as String,
        quantity: json['quantity'] as int,
        salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0,
      );
}

