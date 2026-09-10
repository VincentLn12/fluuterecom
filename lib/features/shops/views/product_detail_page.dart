import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/product_detail_controller.dart';
import '../models/product_model.dart';
import '../widgets/product_detail/product_detail_bottom_bar.dart';
import '../widgets/product_detail/product_detail_gallery.dart';
import '../widgets/product_detail/product_detail_info_panel.dart';
import '../widgets/product_detail/product_detail_other_products.dart';
import '../widgets/product_detail/product_detail_seller_card.dart';
import '../widgets/product_detail/product_detail_tabs.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF332820),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'รายละเอียดสินค้า',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'ตะกร้าสินค้า',
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () => Get.toNamed(AppRoutes.cart),
          ),
        ],
      ),
      body: Obx(() {
        final product = controller.product.value;
        final sellerShop = controller.sellerShop.value;
        final isLoading = controller.isLoading.value;

        if (isLoading && product == null) {
          return const Center(
            child: LoadingWidget(message: 'กำลังโหลดข้อมูลสินค้า...'),
          );
        }

        if (product == null) {
          return Center(
            child: CustomErrorWidget(
              message: 'ไม่พบรายละเอียดสินค้าในระบบ',
              onRetry: () {
                final args = Get.arguments;
                if (args != null) {
                  controller.loadProductAndShop(
                    args is String ? args : (args as ProductModel).id,
                    null,
                  );
                }
              },
            ),
          );
        }

        // Build list of image URLs from real product model
        final allImages = <String>[];
        if (product.imageUrl != null && product.imageUrl!.trim().isNotEmpty) {
          allImages.add(product.imageUrl!.trim());
        }
        for (final img in product.detailImages) {
          if (img.trim().isNotEmpty && !allImages.contains(img.trim())) {
            allImages.add(img.trim());
          }
        }

        return RefreshIndicator(
          onRefresh: () =>
              controller.loadProductAndShop(product.id, product.shopId),
          color: const Color(0xFFD96C2C),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. MAIN DISPLAY FRAME (GALLERY & INFO)
                Container(
                  color: const Color(0xFFFFF9F2),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Gallery
                      ProductDetailGallery(product: product, images: allImages),

                      const SizedBox(height: 16),

                      // Product Info & Price Panel
                      ProductDetailInfoPanel(
                        product: product,
                        shop: sellerShop,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 2. SUB-NAV TABS (DETAILS & REVIEWS)
                const ProductDetailNavTabs(),

                // Tab Content View
                Obx(() {
                  if (controller.activeTab.value == 'details') {
                    return ProductDetailsTabContent(product: product);
                  } else {
                    return ProductReviewsTabContent(
                      reviews: controller.shopReviews,
                    );
                  }
                }),

                const SizedBox(height: 14),

                // 3. SELLER CARD
                if (sellerShop != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: ProductDetailSellerCard(shop: sellerShop),
                  ),

                const SizedBox(height: 20),

                // 4. OTHER PRODUCTS FROM THIS SHOP
                Obx(() {
                  if (controller.otherShopProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ProductDetailOtherProducts(
                    title: 'สินค้าอื่นจากร้านนี้',
                    shopId: sellerShop?.id,
                    products: controller.otherShopProducts,
                  );
                }),

                const SizedBox(height: 90), // Spacing for bottom bar
              ],
            ),
          ),
        );
      }),

      // BOTTOM ACTION BAR FOR MOBILE
      bottomNavigationBar: const ProductDetailBottomBar(),
    );
  }
}
