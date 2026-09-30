import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_cta_banner.dart';
import '../widgets/home_district_transit_map.dart';
import '../widgets/home_hero_slider.dart';
import '../widgets/home_products_section.dart';
import '../widgets/home_deals_section.dart';
import '../widgets/home_search_header.dart';
import '../widgets/home_shops_section.dart';
import '../widgets/home_stories_section.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  // High-Contrast Color Palette
  static const Color brandPrimary = Color(0xFFC85A17);
  static const Color darkHeader = Color(0xFF0F172A);
  static const Color bgCanvas = Color(0xFFECE6DF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: darkHeader,
        elevation: 2,
        toolbarHeight: 72,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KANCHANABURI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'แพลตฟอร์มท่องเที่ยว & สินค้าชุมชน',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFCC80),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/contents'),
            icon: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดหน้าแรก...');
        }
        return RefreshIndicator(
          onRefresh: controller.fetchHomeData,
          color: brandPrimary,
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSearchHeader(),
                SizedBox(height: 20),

                HomeHeroSlider(),

                SizedBox(height: 26),

                HomeDealsSection(),

                SizedBox(height: 26),

                HomeStoriesSection(),

                SizedBox(height: 26),

                HomeDistrictTransitMap(),

                SizedBox(height: 26),

                HomeShopsSection(),

                SizedBox(height: 26),

                HomeProductsSection(),

                SizedBox(height: 26),


                HomeCtaBanner(),

                SizedBox(height: 48),
              ],
            ),
          ),
        );
      }),
    );
  }
}
