import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/shared/widgets/error_widget.dart';
import 'package:projecte/features/shops/controllers/shop_detail_controller.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_about_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_bottom_bar.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_content_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_hero.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_nav_tabs.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_products_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_reviews_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_skeleton.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_summary_card.dart';

class ShopDetailPage extends GetView<ShopDetailController> {
  const ShopDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      body: Obx(() {
        final shop = controller.shop.value;
        final isLoading = controller.isLoading.value;
        final isError = controller.isError.value;

        // 1. Loading State (Skeleton)
        if (isLoading && shop == null) {
          return const ShopDetailSkeleton();
        }

        // 2. Error State
        if (isError || shop == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F382C),
              foregroundColor: Colors.white,
              title: const Text('ไม่พบข้อมูลร้านค้า'),
            ),
            body: Center(
              child: CustomErrorWidget(
                message: controller.errorMessage.value.isNotEmpty
                    ? controller.errorMessage.value
                    : 'ไม่สามารถโหลดข้อมูลร้านค้าได้',
                onRetry: () {
                  final args = Get.arguments;
                  if (args != null) {
                    controller.loadShopDetailAndProducts(
                      args is String ? args : args.id,
                    );
                  }
                },
              ),
            ),
          );
        }

        // 3. Main Loaded View
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await controller.loadShopDetailAndProducts(shop.id);
              },
              color: const Color(0xFF2A9D8F),
              backgroundColor: Colors.white,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // App Bar with Hero Image Banner
                  SliverAppBar(
                    expandedHeight: 220.0,
                    pinned: true,
                    backgroundColor: const Color(0xFF0F382C),
                    foregroundColor: Colors.white,
                    title: Text(
                      shop.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                          onPressed: controller.shareShop,
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ShopDetailHero(shop: shop),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // Main Store Header Card (Logo, Title, Badges, Stats, Actions)
                  SliverToBoxAdapter(
                    child: Obx(
                      () => ShopDetailHeaderCard(
                        shop: shop,
                        rating: controller.averageRating,
                        reviewCount: controller.reviewCount,
                        productCount: controller.products.length,
                        isFollowing: controller.isFollowing.value,
                        onToggleFollow: controller.toggleFollow,
                        onShare: controller.shareShop,
                        onDirections: controller.openDirections,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // Navigation Tabs Bar
                  SliverToBoxAdapter(
                    child: Obx(
                      () => ShopDetailNavTabs(
                        activeIndex: controller.activeTab.value,
                        onTabSelected: controller.setActiveTab,
                        productCount: controller.products.length,
                        contentCount: controller.shopContents.length,
                        reviewCount: controller.reviews.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // Main Content Body based on Selected Tab
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
                    sliver: SliverToBoxAdapter(
                      child: Obx(() {
                        final activeTab = controller.activeTab.value;

                        switch (activeTab) {
                          case 1:
                            // Tab 1: Products
                            return ShopDetailProductsSection(
                              products: controller.filteredProducts,
                              searchQuery: controller.productSearchQuery.value,
                              onSearchChanged: controller.setSearchQuery,
                              sortOption: controller.productSortOption.value,
                              onSortChanged: controller.setSortOption,
                            );

                          case 2:
                            // Tab 2: Content Stories
                            return ShopDetailContentSection(
                              contents: controller.shopContents,
                            );

                          case 3:
                            // Tab 3: About
                            return ShopDetailAboutSection(
                              shop: shop,
                              onCallPhone: (phone) {
                                if (shop.phone != null) {
                                  controller.makePhoneCall(phone);
                                }
                              },
                            );

                          case 4:
                            // Tab 4: Reviews
                            return ShopDetailReviewsSection(
                              reviews: controller.reviews,
                              averageRating: controller.averageRating,
                            );

                          case 0:
                          default:
                            // Tab 0: Overview (All Combined Sections)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Content Section (Hides if empty)
                                ShopDetailContentSection(
                                  contents: controller.shopContents,
                                ),
                                if (controller.shopContents.isNotEmpty)
                                  const SizedBox(height: 16),

                                // Featured Products Grid Section
                                ShopDetailProductsSection(
                                  products: controller.filteredProducts,
                                  searchQuery:
                                      controller.productSearchQuery.value,
                                  onSearchChanged: controller.setSearchQuery,
                                  sortOption:
                                      controller.productSortOption.value,
                                  onSortChanged: controller.setSortOption,
                                ),
                                const SizedBox(height: 18),

                                // About Section
                                ShopDetailAboutSection(
                                  shop: shop,
                                  onCallPhone: (phone) {
                                    if (shop.phone != null) {
                                      controller.makePhoneCall(phone);
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Customer Reviews Section
                                ShopDetailReviewsSection(
                                  reviews: controller.reviews,
                                  averageRating: controller.averageRating,
                                ),
                              ],
                            );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom Action Bar for Mobile
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Obx(
                () => ShopDetailBottomBar(
                  isFollowing: controller.isFollowing.value,
                  onToggleFollow: controller.toggleFollow,
                  onCall: () {
                    if (shop.phone != null && shop.phone!.isNotEmpty) {
                      controller.makePhoneCall(shop.phone!);
                    } else {
                      Get.snackbar(
                        'ไม่มีเบอร์โทรศัพท์',
                        'ร้านค้านี้ยังไม่ได้ระบุเบอร์โทรศัพท์',
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  onDirections: controller.openDirections,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
