import '../../shops/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String? shopName;
  int quantity;
  bool isSelected;

  CartItemModel({
    required this.id,
    required this.product,
    this.shopName,
    this.quantity = 1,
    this.isSelected = true,
  });

  double get subtotal => product.price * quantity;

  String get effectiveShopId =>
      product.shopId.isNotEmpty ? product.shopId : 'unknown_shop';

  String get effectiveShopName => (shopName != null && shopName!.isNotEmpty)
      ? shopName!
      : (product.shopName != null && product.shopName!.isNotEmpty)
      ? product.shopName!
      : 'ร้านค้าชุมชน';

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productId = json['productId']?.toString() ?? '';
    final productName = json['productName']?.toString() ?? 'สินค้า';
    final shopId = json['shopId']?.toString() ?? '';
    final shopName = json['shopName']?.toString();
    final imageUrl = json['imageUrl']?.toString() ?? '';
    final unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final quantity = (json['quantity'] as num?)?.toInt() ?? 1;

    final product = ProductModel(
      id: productId,
      name: productName,
      description: '',
      price: unitPrice,
      quantity: (json['availableQuantity'] as num?)?.toInt() ?? 100,
      imageUrl: imageUrl,
      shopId: shopId,
      shopName: shopName,
    );

    return CartItemModel(
      id:
          json['cartItemId']?.toString() ??
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      shopName: shopName,
      quantity: quantity,
      isSelected: true,
    );
  }

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? shopName,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      shopName: shopName ?? this.shopName,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
