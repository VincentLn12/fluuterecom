import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_categories_controller.dart';
import '../models/admin_category_model.dart';

class ManageCategoriesPage extends GetView<AdminCategoriesController> {
  const ManageCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminCategoriesController>()) {
      Get.put(AdminCategoriesController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'จัดการหมวดหมู่ (Categories)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primary,
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.switchTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: controller.activeTab.value == 0 ? AppColors.accent : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'หมวดหมู่ร้านค้า',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              color: controller.activeTab.value == 0 ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.switchTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: controller.activeTab.value == 1 ? AppColors.accent : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'หมวดหมู่สินค้า',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              color: controller.activeTab.value == 1 ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          if (controller.activeTab.value == 0) {
            _showShopCategoryForm(context);
          } else {
            _showProductCategoryForm(context);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.activeTab.value == 0) {
          if (controller.isShopLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = controller.shopCategories;
          if (items.isEmpty) {
            return Center(child: Text('ไม่มีหมวดหมู่ร้านค้า', style: GoogleFonts.krub()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cat = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.category_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.categoryName, style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 15)),
                          if (cat.description != null && cat.description!.isNotEmpty)
                            Text(cat.description!, style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _showShopCategoryForm(context, category: cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => controller.deleteShopCategory(cat.shopCategoryId),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          if (controller.isProductLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = controller.productCategories;
          if (items.isEmpty) {
            return Center(child: Text('ไม่มีหมวดหมู่สินค้า', style: GoogleFonts.krub()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cat = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accent.withOpacity(0.1),
                      child: const Icon(Icons.shopping_bag_outlined, color: AppColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.categoryName, style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 15)),
                          if (cat.description != null && cat.description!.isNotEmpty)
                            Text(cat.description!, style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _showProductCategoryForm(context, category: cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => controller.deleteProductCategory(cat.productCategoryId),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _showShopCategoryForm(BuildContext context, {ShopCategoryAdmin? category}) {
    final nameCtrl = TextEditingController(text: category?.categoryName ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    String status = category?.status ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'สร้างหมวดหมู่ร้านค้า' : 'แก้ไขหมวดหมู่ร้านค้า', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'ชื่อหมวดหมู่ร้านค้า', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'คำอธิบาย', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (category == null) {
                await controller.createShopCategory(nameCtrl.text.trim(), descCtrl.text.trim());
              } else {
                await controller.updateShopCategory(category.shopCategoryId, nameCtrl.text.trim(), descCtrl.text.trim(), status);
              }
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showProductCategoryForm(BuildContext context, {ProductCategoryAdmin? category}) {
    final nameCtrl = TextEditingController(text: category?.categoryName ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    String status = category?.status ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'สร้างหมวดหมู่สินค้า' : 'แก้ไขหมวดหมู่สินค้า', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'ชื่อหมวดหมู่สินค้า', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'คำอธิบาย', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (category == null) {
                await controller.createProductCategory(nameCtrl.text.trim(), descCtrl.text.trim());
              } else {
                await controller.updateProductCategory(category.productCategoryId, nameCtrl.text.trim(), descCtrl.text.trim(), status);
              }
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
