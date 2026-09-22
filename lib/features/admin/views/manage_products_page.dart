import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_products_controller.dart';

class ManageProductsPage extends GetView<AdminProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminProductsController>()) {
      Get.put(AdminProductsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.shopName.value.isNotEmpty
                ? 'สินค้าในร้าน: ${controller.shopName.value}'
                : 'จัดการสินค้าในร้านค้า',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => Row(
                children: [
                  Text(
                    'กรองสถานะ: ',
                    style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      'ทั้งหมด',
                      style: GoogleFonts.krub(fontSize: 11),
                    ),
                    selected: controller.selectedStatus.value == '',
                    onSelected: (s) {
                      if (s) {
                        controller.selectedStatus.value = '';
                        controller.loadProducts(page: 1);
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text(
                      'วางขาย (Active)',
                      style: GoogleFonts.krub(fontSize: 11),
                    ),
                    selected: controller.selectedStatus.value == 'Active',
                    onSelected: (s) {
                      if (s) {
                        controller.selectedStatus.value = 'Active';
                        controller.loadProducts(page: 1);
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text(
                      'ระงับการขาย (Inactive)',
                      style: GoogleFonts.krub(fontSize: 11),
                    ),
                    selected: controller.selectedStatus.value == 'Inactive',
                    onSelected: (s) {
                      if (s) {
                        controller.selectedStatus.value = 'Inactive';
                        controller.loadProducts(page: 1);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Products List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final products = controller.products;
              if (products.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่พบรายการสินค้าในร้านค้านี้',
                    style: GoogleFonts.krub(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  final isActive = p.status.toLowerCase() == 'active';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            p.imageUrl ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'ราคา: ฿${p.price.toStringAsFixed(2)} | คลัง: ${p.quantity} ชิ้น',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: isActive,
                              activeTrackColor: AppColors.primary,
                              onChanged: (val) => controller
                                  .toggleProductStatus(p.id, p.status),
                            ),
                            Text(
                              isActive ? 'วางขายอยู่' : 'ระงับการขาย',
                              style: GoogleFonts.krub(
                                fontSize: 10,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
