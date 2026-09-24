import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';

class ManageContentsEmptyState extends GetView<ManageContentsController> {
  const ManageContentsEmptyState({super.key, required this.isShopNull});

  final bool isShopNull;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isShopNull
                    ? const Color(0xFFFFF7ED)
                    : const Color(0xFFECFDF5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isShopNull
                      ? const Color(0xFFFFEDD5)
                      : const Color(0xFFA7F3D0),
                  width: 2,
                ),
              ),
              child: Icon(
                isShopNull
                    ? Icons.storefront_rounded
                    : Icons.auto_stories_rounded,
                size: 56,
                color: isShopNull
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isShopNull
                  ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                  : 'ยังไม่มีเรื่องราว หรือ ข่าวสาร',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isShopNull
                  ? 'กรุณากรอกข้อมูลเพื่อเปิดร้านค้าก่อนเขียนเรื่องราวและประชาสัมพันธ์สินค้า'
                  : 'เล่าเรื่องราวความเป็นมา โปรโมชั่นพิเศษ หรือข่าวสารน่าสนใจเพื่อดึงดูดลูกค้า',
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
                if (isShopNull) {
                  Get.toNamed(AppRoutes.registerShop);
                } else {
                  final res = await Get.toNamed(AppRoutes.myShopContentForm);
                  if (res == true) {
                    controller.loadContents();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isShopNull
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
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
                isShopNull ? Icons.edit_document : Icons.add_rounded,
                size: 20,
              ),
              label: Text(
                isShopNull
                    ? 'ลงทะเบียนร้านค้าใหม่'
                    : 'สร้างเรื่องราวแรกของร้าน',
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
