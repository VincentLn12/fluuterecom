import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/product_detail_controller.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';
import '../models/shop_review_model.dart';

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
                      _buildProductGallery(product, allImages),

                      const SizedBox(height: 16),

                      // Product Info & Price Panel
                      _buildProductInfoPanel(product, sellerShop),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 3. SUB-NAV TABS (DETAILS & REVIEWS)
                _buildSubNavTabs(),

                // Tab Content View
                Obx(() {
                  if (controller.activeTab.value == 'details') {
                    return _buildDetailsTabContent(product);
                  } else {
                    return _buildReviewsTabContent(controller.shopReviews);
                  }
                }),

                const SizedBox(height: 14),

                // 4. SELLER CARD
                if (sellerShop != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _buildSellerCard(sellerShop),
                  ),

                const SizedBox(height: 20),

                // 5. OTHER PRODUCTS FROM THIS SHOP
                Obx(() {
                  if (controller.otherShopProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _buildProductsSection(
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
      bottomNavigationBar: Obx(() {
        final product = controller.product.value;
        if (product == null) return const SizedBox.shrink();

        final inStock = product.quantity > 0;
        final subtotal = product.price * controller.quantity.value;

        return Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF332820).withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Quick Add To Cart Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: inStock ? controller.addToCart : null,
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                    label: Text(
                      'ใส่ตะกร้า',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD96C2C),
                      side: const BorderSide(
                        color: Color(0xFFD96C2C),
                        width: 1.8,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Buy Now Button
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: inStock ? controller.buyNow : null,
                    icon: const Icon(
                      Icons.bolt_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      inStock
                          ? 'ซื้อเลย • ฿${subtotal.toStringAsFixed(0)}'
                          : 'สินค้าหมด',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD96C2C),
                      disabledBackgroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // 1. PRODUCT GALLERY WITH MOBILE RESPONSIVE ASPECT RATIO
  Widget _buildProductGallery(ProductModel product, List<String> images) {
    return Column(
      children: [
        // Main Preview Image Frame
        Obx(() {
          final selectedIdx = controller.selectedImageIndex.value;
          final hasImages = images.isNotEmpty;
          final currentImage = hasImages && selectedIdx < images.length
              ? images[selectedIdx]
              : null;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF171412),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: currentImage != null
                        ? Image.network(
                            currentImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),

                  // Top Left Status Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '✨ สินค้าแนะนำ',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Top Right Favorite Button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Obx(
                      () => Material(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: controller.toggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              controller.isFavorite.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: controller.isFavorite.value
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFFD96C2C),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gallery Prev / Next Arrows
                  if (images.length > 1) ...[
                    Positioned(
                      left: 6,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF332820),
                              size: 20,
                            ),
                            onPressed: () {
                              int prev =
                                  (selectedIdx - 1 + images.length) %
                                  images.length;
                              controller.selectImage(prev);
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF332820),
                              size: 20,
                            ),
                            onPressed: () {
                              int next = (selectedIdx + 1) % images.length;
                              controller.selectImage(next);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Bottom Image Indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${selectedIdx + 1} / ${images.length}',
                          style: GoogleFonts.krub(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),

        // Thumbnails Strip
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected =
                      controller.selectedImageIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectImage(index),
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFD96C2C)
                              : const Color(0xFFE8D9C9),
                          width: isSelected ? 2.2 : 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  // 3. PRODUCT INFO & PRICING PANEL (WITHOUT MOCK DATA)
  Widget _buildProductInfoPanel(ProductModel product, ShopModel? shop) {
    final inStock = product.quantity > 0;
    final reviews = controller.shopReviews;

    // Real review stats computation
    final double avgRating = reviews.isNotEmpty
        ? (reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length)
        : 5.0;
    final int reviewCount = reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Tag Pill
        if (shop?.categoryName != null && shop!.categoryName!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  size: 13,
                  color: Color(0xFFD96C2C),
                ),
                const SizedBox(width: 4),
                Text(
                  shop.categoryName!,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ),

        // Product Name
        Text(
          product.name,
          style: GoogleFonts.krub(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
            height: 1.25,
          ),
        ),

        const SizedBox(height: 10),

        // Seller Link Box
        if (shop != null) ...[
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: shop),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8D9C9)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        shop.coverImageUrl != null &&
                            shop.coverImageUrl!.isNotEmpty
                        ? NetworkImage(shop.coverImageUrl!)
                        : null,
                    child:
                        shop.coverImageUrl == null ||
                            shop.coverImageUrl!.isEmpty
                        ? const Icon(
                            Icons.storefront_rounded,
                            size: 14,
                            color: Color(0xFFD96C2C),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    shop.name,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFFD96C2C),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Rating & Reviews Status Bar (Real Data)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0xFFE8D9C9)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFD96C2C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reviewCount > 0
                          ? '${avgRating.toStringAsFixed(1)} ($reviewCount รีวิว)'
                          : 'ไม่มีรีวิว',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ),
              if (shop?.districtName != null &&
                  shop!.districtName!.isNotEmpty) ...[
                const SizedBox(width: 10),
                const Text('•', style: TextStyle(color: Color(0xFFE8D9C9))),
                const SizedBox(width: 10),
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 2),
                Text(
                  shop.districtName!,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Price Display Box (Mobile Optimized)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFD96C2C).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ราคาขาย',
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  Text(
                    '฿${product.price.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),

              // Stock Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: inStock
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      inStock ? 'สต็อก ${product.quantity} ชิ้น' : 'สินค้าหมด',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Quantity Selector Row
        Row(
          children: [
            Text(
              'จำนวนที่ต้องการ:',
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
              ),
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.remove_rounded, size: 16),
                    color: const Color(0xFF332820),
                    onPressed: controller.decrementQuantity,
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${controller.quantity.value}',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add_rounded, size: 16),
                    color: const Color(0xFF332820),
                    onPressed: controller.incrementQuantity,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Action CTA Buttons: Add to Cart & Buy Now
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: inStock ? controller.addToCart : null,
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                label: Text(
                  'เพิ่มลงตะกร้า',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD96C2C),
                  side: const BorderSide(color: Color(0xFFD96C2C), width: 1.8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: inStock ? controller.buyNow : null,
                icon: const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'สั่งซื้อทันที',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C2C),
                  disabledBackgroundColor: Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 3 Guarantee Badges
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F0E6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D9C9)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGuaranteeBadge(
                icon: Icons.verified_user_outlined,
                title: 'ชำระเงินปลอดภัย',
                subtitle: 'ระบบมาตรฐาน',
              ),
              _buildGuaranteeBadge(
                icon: Icons.local_shipping_outlined,
                title: 'จัดส่งรวดเร็ว',
                subtitle: '1-3 วันทำการ',
              ),
              _buildGuaranteeBadge(
                icon: Icons.sync_rounded,
                title: 'คืนสินค้าได้',
                subtitle: 'ภายใน 7 วัน',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuaranteeBadge({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD96C2C), size: 20),
        const SizedBox(height: 2),
        Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.krub(
            fontSize: 8.5,
            color: const Color(0xFF786B62),
          ),
        ),
      ],
    );
  }

  // 4. SUB-NAV TABS (DETAILS & REVIEWS)
  Widget _buildSubNavTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF9F2),
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFFE8D9C9), width: 1.2),
        ),
      ),
      child: Obx(() {
        final currentTab = controller.activeTab.value;
        final reviewCount = controller.shopReviews.length;

        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => controller.changeTab('details'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: currentTab == 'details'
                            ? const Color(0xFFD96C2C)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'รายละเอียดสินค้า',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: currentTab == 'details'
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFF786B62),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => controller.changeTab('reviews'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: currentTab == 'reviews'
                            ? const Color(0xFFD96C2C)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'รีวิวจากผู้ซื้อ ($reviewCount)',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: currentTab == 'reviews'
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFF786B62),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // TAB CONTENT: DETAILS
  Widget _buildDetailsTabContent(ProductModel product) {
    final hasDesc =
        product.description != null && product.description!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.5,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'รายละเอียดสินค้า',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasDesc
                ? product.description!
                : 'ไม่มีรายละเอียดเพิ่มเติมสำหรับสินค้าชิ้นนี้',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF332820),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: REVIEWS (REAL DATA ONLY)
  Widget _buildReviewsTabContent(List<ShopReviewModel> reviews) {
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        color: Colors.white,
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: const Color(0xFFD96C2C).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 10),
            Text(
              'ยังไม่มีรีวิวสำหรับสินค้านี้',
              style: GoogleFonts.krub(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'สั่งซื้อสินค้านี้เพื่อเป็นคนแรกที่ร่วมแชร์ความคิดเห็น!',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: const Color(0xFF786B62),
              ),
            ),
          ],
        ),
      );
    }

    final double avgRating =
        reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: GoogleFonts.krub(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFE9C46A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${reviews.length} รีวิว',
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(5, (idx) {
                      final star = 5 - idx;
                      final count = reviews
                          .where((r) => r.rating.round() == star)
                          .length;
                      final pct = count / reviews.length;
                      return _buildRatingBar(star, pct);
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          ...reviews.map(
            (rev) => _buildReviewItem(
              userName: rev.userName,
              rating: rev.rating.round(),
              comment: rev.comment,
              createdAt:
                  '${rev.createdAt.day}/${rev.createdAt.month}/${rev.createdAt.year}',
              reply: rev.ownerReply,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text(
            '$star',
            style: GoogleFonts.krub(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star_rounded, size: 11, color: Color(0xFFE9C46A)),
          const SizedBox(width: 5),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFFE8D9C9),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFD96C2C),
                ),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String userName,
    required int rating,
    required String comment,
    required String createdAt,
    String? reply,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(
                      0xFFD96C2C,
                    ).withValues(alpha: 0.15),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                      Text(
                        createdAt,
                        style: GoogleFonts.krub(
                          fontSize: 9.5,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14,
                    color: index < rating
                        ? const Color(0xFFE9C46A)
                        : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comment,
              style: GoogleFonts.krub(
                fontSize: 12.5,
                color: const Color(0xFF332820),
                height: 1.4,
              ),
            ),
          ],
          if (reply != null && reply.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8D9C9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.reply_rounded,
                        size: 13,
                        color: Color(0xFFD96C2C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ตอบกลับจากร้านค้า:',
                        style: GoogleFonts.krub(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD96C2C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reply,
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      color: const Color(0xFF332820),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 5. SELLER CARD (REAL SHOP DATA ONLY)
  Widget _buildSellerCard(ShopModel shop) {
    final hasPhone = shop.phone != null && shop.phone!.trim().isNotEmpty;
    final hasHours = shop.openingTime != null && shop.closingTime != null;
    final hasAddr = shop.address != null && shop.address!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: Color(0xFFD96C2C),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'ร้านผู้จำหน่าย',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFE8D9C9)),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFD96C2C).withValues(alpha: 0.2),
                backgroundImage:
                    shop.coverImageUrl != null && shop.coverImageUrl!.isNotEmpty
                    ? NetworkImage(shop.coverImageUrl!)
                    : null,
                child: shop.coverImageUrl == null || shop.coverImageUrl!.isEmpty
                    ? const Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFFD96C2C),
                        size: 22,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            shop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.krub(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF332820),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: Color(0xFFD96C2C),
                        ),
                      ],
                    ),
                    Text(
                      '${shop.categoryName ?? 'ร้านค้าชุมชน'} • ${shop.districtName ?? 'กาญจนบุรี'}',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: const Color(0xFF786B62),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPhone || hasHours || hasAddr) ...[
            const SizedBox(height: 12),
            if (hasPhone) ...[
              _buildInfoRow(Icons.phone_outlined, shop.phone!),
              const SizedBox(height: 5),
            ],
            if (hasHours) ...[
              _buildInfoRow(
                Icons.access_time_rounded,
                'เปิด ${shop.openingTime} - ${shop.closingTime} น.',
              ),
              const SizedBox(height: 5),
            ],
            if (hasAddr) ...[
              _buildInfoRow(Icons.location_on_outlined, shop.address!),
            ],
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.shopDetail, arguments: shop),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 1,
              ),
              child: Text(
                'เข้าชมร้านค้า >',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFFD96C2C)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.krub(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
        ),
      ],
    );
  }

  // 6. RECOMMENDED PRODUCTS SECTION
  Widget _buildProductsSection({
    required String title,
    String? shopId,
    required List<ProductModel> products,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (shopId != null) {
                    Get.toNamed(AppRoutes.shopDetail, arguments: shopId);
                  } else {
                    Get.toNamed(AppRoutes.shops);
                  }
                },
                child: Text(
                  'ดูทั้งหมด >',
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFE8D9C9)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return _buildMiniProductCard(p);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniProductCard(ProductModel p) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: p,
          preventDuplicates: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8D9C9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: p.imageUrl != null && p.imageUrl!.trim().isNotEmpty
                    ? Image.network(
                        p.imageUrl!.trim(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '฿${p.price.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF171412),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Colors.white30,
        ),
      ),
    );
  }
}
