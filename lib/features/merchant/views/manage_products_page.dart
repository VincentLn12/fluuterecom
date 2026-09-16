import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/manage_products_controller.dart';

class ManageProductsPage extends GetView<ManageProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'จัดการสินค้าในร้าน',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF047857), size: 28),
            onPressed: () async {
              final result = await Get.toNamed(AppRoutes.myShopProductForm);
              if (result == true) controller.loadProducts();
            },
            tooltip: 'เพิ่มสินค้าใหม่',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดรายการสินค้า...');
        }

        final list = controller.filteredProducts;

        return RefreshIndicator(
          onRefresh: controller.loadProducts,
          color: const Color(0xFF047857),
          child: Column(
            children: [
              // Search Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  style: GoogleFonts.krub(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'ค้นหาชื่อสินค้า...',
                    hintStyle: GoogleFonts.krub(color: const Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Product List
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.myShop.value == null
                                    ? Icons.storefront_outlined
                                    : Icons.inventory_2_outlined,
                                size: 64,
                                color: const Color(0xFFCBD5E1),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.myShop.value == null
                                    ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                                    : 'ยังไม่มีสินค้าในร้านของคุณ',
                                style: GoogleFonts.krub(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.myShop.value == null
                                    ? 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าก่อนเริ่มเพิ่มรายการสินค้า'
                                    : 'เพิ่มสินค้าเข้าสู่ร้านค้าเพื่อให้ผู้ใช้งานสามารถสั่งซื้อได้',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (controller.myShop.value == null) {
                                    Get.toNamed(AppRoutes.registerShop);
                                  } else {
                                    final result = await Get.toNamed(AppRoutes.myShopProductForm);
                                    if (result == true) controller.loadProducts();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.myShop.value == null
                                      ? const Color(0xFFD97706)
                                      : const Color(0xFF047857),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(
                                  controller.myShop.value == null ? Icons.edit_document : Icons.add,
                                  size: 18,
                                ),
                                label: Text(
                                  controller.myShop.value == null
                                      ? 'ลงทะเบียนร้านค้าใหม่'
                                      : 'เพิ่มสินค้าแรกของคุณ',
                                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = list[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          product.imageUrl!,
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Container(
                                            width: 64,
                                            height: 64,
                                            color: const Color(0xFFF1F5F9),
                                            child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8)),
                                          ),
                                        )
                                      : Container(
                                          width: 64,
                                          height: 64,
                                          color: const Color(0xFFECFDF5),
                                          child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF059669)),
                                        ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: GoogleFonts.krub(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '฿${product.price.toStringAsFixed(0)}',
                                            style: GoogleFonts.krub(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF047857),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'สต็อก: ${product.quantity}',
                                            style: GoogleFonts.krub(
                                              fontSize: 12,
                                              color: product.quantity <= 5
                                                  ? const Color(0xFFE11D48)
                                                  : const Color(0xFF64748B),
                                              fontWeight: product.quantity <= 5
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF0284C7), size: 22),
                                      onPressed: () async {
                                        final result = await Get.toNamed(
                                          AppRoutes.myShopProductForm,
                                          arguments: product,
                                        );
                                        if (result == true) controller.loadProducts();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48), size: 22),
                                      onPressed: () => controller.confirmDeleteProduct(product),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
