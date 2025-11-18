class OrderDetail {
  final int id;
  final int productId;
  final String? productName;
  final int storeId;
  final String? storeName;
  final int quantity;
  final double unitPrice;

  OrderDetail({
    required this.id,
    required this.productId,
    this.productName,
    required this.storeId,
    this.storeName,
    required this.quantity,
    required this.unitPrice,
  });
}




