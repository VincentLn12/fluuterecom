import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_content_card.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_empty_state.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_hero.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_search_field.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ManageContentsPage extends GetView<ManageContentsController> {
  const ManageContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'จัดการเรื่องราว & ข่าวสารร้าน',
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
            onPressed: controller.loadContents,
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.myShopContentForm);
          if (result == true) controller.loadContents();
        },
        backgroundColor: const Color(0xFF047857),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
        label: Text(
          'เขียนเรื่องราวใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดบทความและข่าวสาร...');
        }

        final contents = controller.filteredContents;
        final totalViews = controller.contents.fold<int>(
          0,
          (sum, item) => sum + item.viewCount,
        );

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ManageContentsHero(
                shopName: controller.myShop.value?.shopName,
                totalContents: controller.contents.length,
                totalViews: totalViews,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 44)),
            SliverToBoxAdapter(
              child: ManageContentsSearchField(controller: controller),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (contents.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ManageContentsEmptyState(
                  isShopNull: controller.myShop.value == null,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = contents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ManageContentCard(item: item),
                    );
                  }, childCount: contents.length),
                ),
              ),
          ],
        );
      }),
    );
  }
}
