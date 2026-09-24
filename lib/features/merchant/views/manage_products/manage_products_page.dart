import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_product_card.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_empty_state.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_stat_card.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_search_field.dart';

class ManageProductsPage extends GetView<ManageProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F5F9,
      ), // High contrast grey page background
      appBar: AppBar(
        title: Text(
          'จัดการสินค้าในร้าน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'รีเฟรช',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => controller.loadProducts(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (controller.myShop.value == null) {
            Get.toNamed(AppRoutes.registerShop);
          } else {
            final result = await Get.toNamed(AppRoutes.myShopProductForm);
            if (result == true) controller.loadProducts();
          }
        },
        backgroundColor: const Color(0xFF047857),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 24),
        label: Text(
          'เพิ่มสินค้าใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดรายการสินค้า...');
        }

        final list = controller.filteredProducts;
        final totalCount = controller.products.length;
        final lowStockCount = controller.products
            .where((p) => p.quantity <= 5)
            .length;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Top Hero Banner
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient Background Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 48),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF064E3B),
                          Color(0xFF047857),
                          Color(0xFF059669),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Colors.amberAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.myShop.value?.shopName ??
                                    'รายการสินค้าในคลัง',
                                style: GoogleFonts.krub(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'จัดการข้อมูลราคา จำนวนสต็อก และรูปภาพสินค้าในร้าน',
                                style: GoogleFonts.krub(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Summary Cards (Overlapping)
                  Positioned(
                    bottom: -32,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: ManageProductsStatCard(
                            title: 'สินค้าทั้งหมด',
                            value: '$totalCount รายการ',
                            icon: Icons.inventory_2_rounded,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ManageProductsStatCard(
                            title: lowStockCount > 0
                                ? 'สต็อกเตือน/หมด'
                                : 'สต็อกพร้อมขาย',
                            value: lowStockCount > 0
                                ? '$lowStockCount รายการ'
                                : 'ปกติทุกรายการ',
                            icon: lowStockCount > 0
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            gradient: lowStockCount > 0
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFE11D48),
                                      Color(0xFFF43F5E),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF0284C7),
                                      Color(0xFF38BDF8),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 44)),

            ManageProductsSearchField(controller: controller),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Main Product List / Empty View
            if (list.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ManageProductsEmptyState(controller: controller),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = list[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ManageProductCard(
                        controller: controller,
                        product: product,
                      ),
                    );
                  }, childCount: list.length),
                ),
              ),
          ],
        );
      }),
    );
  }
}
