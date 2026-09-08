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

  String get effectiveShopName =>
      (shopName != null && shopName!.isNotEmpty)
          ? shopName!
          : (product.shopName != null && product.shopName!.isNotEmpty)
              ? product.shopName!
              : 'ร้านค้าชุมชน';

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
