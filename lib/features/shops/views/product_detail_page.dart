import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      body: Obx(() {
        final product = controller.product.value;
        final sellerShop = controller.sellerShop.value;
        final isLoading = controller.isLoading.value;

        if (isLoading && product == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F0E6),
            body: Center(
              child: LoadingWidget(message: 'กำลังโหลดข้อมูลสินค้า...'),
            ),
          );
        }

        if (product == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF2B1F17),
              foregroundColor: Colors.white,
              title: Text('ไม่พบข้อมูลสินค้า', style: GoogleFonts.krub()),
            ),
            body: Center(
              child: CustomErrorWidget(
                message: 'ไม่สามารถโหลดรายละเอียดสินค้าได้',
                onRetry: () {
                  final args = Get.arguments;
                  if (args != null) {
                    controller.loadProductAndShop(
                      args is String ? args : args.id,
                      null,
                    );
                  }
                },
              ),
            ),
          );
        }

        final allImages = <String>[];
        if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
          allImages.add(product.imageUrl!);
        }
        for (final img in product.detailImages) {
          if (img.isNotEmpty && !allImages.contains(img)) {
            allImages.add(img);
          }
        }

        final inStock = product.quantity > 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F0E6),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Image Header SliverAppBar
              SliverAppBar(
                expandedHeight: 320.0,
                pinned: true,
                backgroundColor: const Color(0xFF2B1F17),
                foregroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (allImages.isNotEmpty)
                        PageView.builder(
                          itemCount: allImages.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              allImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                            );
                          },
                        )
                      else
                        _buildImagePlaceholder(),

                      // Top dark gradient protection for back button
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Image count indicator pill
                      if (allImages.length > 1)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.photo_library_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '1 / ${allImages.length}',
                                  style: GoogleFonts.krub(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Product Info & Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Main Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFEADCCF),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF332820,
                              ).withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stock Badge & Price Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatusBadge(
                                  label: inStock
                                      ? 'มีสินค้าพร้อมส่ง (${product.quantity} ชิ้น)'
                                      : 'สินค้าหมด',
                                  backgroundColor: inStock
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFC62828),
                                  icon: inStock
                                      ? Icons.check_circle_outline
                                      : Icons.highlight_off,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Product Name
                            Text(
                              product.name,
                              style: GoogleFonts.krub(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Price Tag Display
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '฿',
                                  style: GoogleFonts.krub(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD96C2C),
                                  ),
                                ),
                                Text(
                                  product.price.toStringAsFixed(2),
                                  style: GoogleFonts.krub(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFD96C2C),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '/ ชิ้น',
                                  style: GoogleFonts.krub(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Seller Shop Information Card
                      if (sellerShop != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFEADCCF),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF332820,
                                ).withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Shop avatar / icon
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F0E6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD96C2C),
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      sellerShop.coverImageUrl != null &&
                                          sellerShop.coverImageUrl!.isNotEmpty
                                      ? Image.network(
                                          sellerShop.coverImageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.storefront_rounded,
                                                    color: Color(0xFFD96C2C),
                                                    size: 28,
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.storefront_rounded,
                                          color: Color(0xFFD96C2C),
                                          size: 28,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sellerShop.name,
                                      style: GoogleFonts.krub(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2B1F17),
                                      ),
                                    ),
                                    if (sellerShop.districtName != null &&
                                        sellerShop.districtName!.isNotEmpty)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 14,
                                            color: Color(0xFF1F5F58),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            sellerShop.districtName!,
                                            style: GoogleFonts.krub(
                                              fontSize: 13,
                                              color: const Color(0xFF1F5F58),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.shopDetail,
                                    arguments: sellerShop,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFD96C2C),
                                  side: const BorderSide(
                                    color: Color(0xFFD96C2C),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  'ดูร้านค้า',
                                  style: GoogleFonts.krub(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Description Section Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFEADCCF),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF332820,
                              ).withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD96C2C),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'รายละเอียดสินค้า',
                                  style: GoogleFonts.krub(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2B1F17),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.description != null &&
                                      product.description!.isNotEmpty
                                  ? product.description!
                                  : 'ไม่มีรายละเอียดเพิ่มเติมสำหรับสินค้าชิ้นนี้',
                              style: GoogleFonts.krub(
                                fontSize: 15,
                                color: Colors.grey[800],
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // Spacing for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar for Quantity & Cart
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF332820).withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity Counter
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F0E6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEADCCF)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          color: const Color(0xFF2B1F17),
                          onPressed: controller.decrementQuantity,
                        ),
                        Obx(
                          () => Text(
                            '${controller.quantity.value}',
                            style: GoogleFonts.krub(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2B1F17),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          color: const Color(0xFF2B1F17),
                          onPressed: controller.incrementQuantity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Add to Cart Button with Subtotal Price
                  Expanded(
                    child: Obx(() {
                      final subtotal =
                          product.price * controller.quantity.value;

                      return ElevatedButton(
                        onPressed: inStock
                            ? () {
                                Get.find<CartController>().addToCart(
                                  product,
                                  quantity: controller.quantity.value,
                                  shopName: sellerShop?.name,
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD96C2C),
                          disabledBackgroundColor: Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              inStock
                                  ? 'ใส่ตะกร้า • ฿${subtotal.toStringAsFixed(2)}'
                                  : 'สินค้าหมด',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF2B1F17),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 64,
          color: Colors.white30,
        ),
      ),
    );
  }
}
