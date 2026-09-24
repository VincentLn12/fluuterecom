import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';

class ManageProductsEmptyState extends StatelessWidget {
  const ManageProductsEmptyState({super.key, required this.controller});

  final ManageProductsController controller;

  @override
  Widget build(BuildContext context) {
    final isNoShop = controller.myShop.value == null;
    final isSearching = controller.searchQuery.value.isNotEmpty;

    String title = 'ยังไม่มีสินค้าในร้านของคุณ';
    String subtitle =
        'เพิ่มสินค้าเข้าสู่ร้านค้าเพื่อให้ผู้ใช้งานสามารถสั่งซื้อได้';
    IconData icon = Icons.inventory_2_outlined;
    String btnText = 'เพิ่มสินค้าแรกของคุณ';
    Color btnColor = const Color(0xFF047857);

    if (isNoShop) {
      title = 'ยังไม่ได้ลงทะเบียนร้านค้า';
      subtitle = 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าก่อนเริ่มเพิ่มรายการสินค้า';
      icon = Icons.storefront_outlined;
      btnText = 'ลงทะเบียนร้านค้าใหม่';
      btnColor = const Color(0xFFD97706);
    } else if (isSearching) {
      title = 'ไม่พบสินค้าตามคำค้นหา';
      subtitle = 'ลองค้นหาด้วยคำอื่น หรือล้างช่องค้นหาเพื่อดูสินค้าทั้งหมด';
      icon = Icons.search_off_rounded;
      btnText = 'ล้างคำค้นหา';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isNoShop
                    ? const Color(0xFFFFF7ED)
                    : const Color(0xFFECFDF5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isNoShop
                      ? const Color(0xFFFFEDD5)
                      : const Color(0xFFA7F3D0),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 54,
                color: isNoShop
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                if (isSearching) {
                  controller.searchQuery.value = '';
                } else if (isNoShop) {
                  Get.toNamed(AppRoutes.registerShop);
                } else {
                  final result = await Get.toNamed(AppRoutes.myShopProductForm);
                  if (result == true) controller.loadProducts();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              icon: Icon(
                isSearching
                    ? Icons.refresh_rounded
                    : (isNoShop ? Icons.edit_document : Icons.add_rounded),
                size: 20,
              ),
              label: Text(
                btnText,
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
