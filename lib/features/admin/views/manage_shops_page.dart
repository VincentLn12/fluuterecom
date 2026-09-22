import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_products_controller.dart';
import '../controllers/admin_shops_controller.dart';

class ManageShopsPage extends GetView<AdminShopsController> {
  const ManageShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminShopsController>()) {
      Get.put(AdminShopsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'อนุมัติและจัดการร้านค้า (Shop Management)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search Header Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Search Input
                TextField(
                  onChanged: (val) {
                    controller.searchQuery.value = val;
                    controller.loadShops(page: 1);
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหาชื่อร้านค้า...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Status Filter Chips
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('', 'ทั้งหมด'),
                        _buildFilterChip('Pending', 'รออนุมัติ (Pending)'),
                        _buildFilterChip('Active', 'เปิดใช้งาน (Active)'),
                        _buildFilterChip('Suspended', 'ถูกระงับ (Suspended)'),
                        _buildFilterChip('Closed', 'ปิดบริการ (Closed)'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Shop List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final shops = controller.shops;
              if (shops.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่พบรายการร้านค้า',
                    style: GoogleFonts.krub(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              backgroundImage: shop.coverImageUrl != null
                                  ? NetworkImage(shop.coverImageUrl!)
                                  : null,
                              child: shop.coverImageUrl == null
                                  ? const Icon(
                                      Icons.store,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.shopName,
                                    style: GoogleFonts.krub(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'โทร: ${shop.phone ?? '-'} | อีเมล: ${shop.email ?? '-'}',
                                    style: GoogleFonts.krub(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusBadge(shop.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'หมวดหมู่: ${shop.categoryName ?? '-'} | ที่อยู่: ${shop.address ?? '-'}',
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                              ),
                              label: Text(
                                'ดูสินค้าในร้าน',
                                style: GoogleFonts.krub(fontSize: 12),
                              ),
                              onPressed: () {
                                final productsCtrl = Get.put(
                                  AdminProductsController(),
                                );
                                productsCtrl.setShop(
                                  shop.shopId,
                                  shop.shopName,
                                );
                                Get.toNamed(
                                  AppRoutes.myShopProducts,
                                ); // mapped to products view
                              },
                            ),
                            PopupMenuButton<String>(
                              onSelected: (newStatus) => controller
                                  .changeShopStatus(shop.shopId, newStatus),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Active',
                                  child: Text('อนุมัติ/เปิดใช้งาน (Active)'),
                                ),
                                const PopupMenuItem(
                                  value: 'Suspended',
                                  child: Text('ระงับการใช้งาน (Suspended)'),
                                ),
                                const PopupMenuItem(
                                  value: 'Closed',
                                  child: Text('ปิดบริการ (Closed)'),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'เปลี่ยนสถานะ',
                                      style: GoogleFonts.krub(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
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

  Widget _buildFilterChip(String value, String label) {
    final isSelected = controller.selectedStatus.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey[200],
        onSelected: (selected) {
          if (selected) {
            controller.selectedStatus.value = value;
            controller.loadShops(page: 1);
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'active':
        bg = AppColors.primary.withOpacity(0.12);
        text = AppColors.primary;
        break;
      case 'pending':
        bg = AppColors.accent.withOpacity(0.12);
        text = AppColors.accent;
        break;
      case 'suspended':
        bg = AppColors.error.withOpacity(0.12);
        text = AppColors.error;
        break;
      default:
        bg = Colors.grey.withOpacity(0.12);
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
