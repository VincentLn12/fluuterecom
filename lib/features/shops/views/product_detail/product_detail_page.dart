import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_bottom_bar.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_gallery.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_info_panel.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_seller_card.dart';
import 'package:projecte/shared/widgets/error_widget.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Obx(() {
        final product = controller.product.value;
        final sellerShop = controller.sellerShop.value;
        if (controller.isLoading.value && product == null) {
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

        final images = <String>[
          if (product.imageUrl?.trim().isNotEmpty == true)
            product.imageUrl!.trim(),
          ...product.detailImages.where(
            (image) =>
                image.trim().isNotEmpty && image.trim() != product.imageUrl,
          ),
        ];

        return RefreshIndicator(
          onRefresh: () =>
              controller.loadProductAndShop(product.id, product.shopId),
          color: const Color(0xFFEE4D2D),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ProductDetailGallery(product: product, images: images),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: ProductDetailInfoPanel(
                      product: product,
                      shop: sellerShop,
                    ),
                  ),
                ),
                if (product.description?.trim().isNotEmpty == true)
                  SliverToBoxAdapter(
                    child: _DescriptionCard(description: product.description!),
                  ),
                if (sellerShop != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                      child: ProductDetailSellerCard(shop: sellerShop),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const ProductDetailBottomBar(),
    );
  }
}

class _DescriptionCard extends StatefulWidget {
  const _DescriptionCard({required this.description});

  final String description;

  @override
  State<_DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<_DescriptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isLong = widget.description.length > 150;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รายละเอียดสินค้า',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            widget.description,
            maxLines: isLong && !_expanded ? 3 : null,
            overflow: isLong && !_expanded ? TextOverflow.ellipsis : null,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF555555),
            ),
          ),
          if (isLong)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEE4D2D),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(0, 34),
                ),
                child: Text(_expanded ? 'ย่อรายละเอียด' : 'ดูเพิ่มเติม  ›'),
              ),
            ),
        ],
      ),
    );
  }
}
