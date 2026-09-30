import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_card.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_flash_sale_section.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_interactive_map_view.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_list_filters.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_list_header.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late final ShopController controller;
  late final TextEditingController searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ShopController>();
    searchController = TextEditingController(
      text: controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.isEmpty) {
      controller.setSearch('');
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => controller.setSearch(query),
    );
  }

  void _clearFilters() {
    _searchDebounce?.cancel();
    searchController.clear();
    controller.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopListPalette.canvas,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C2B22),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(
              Icons.storefront_rounded,
              size: 22,
              color: ShopListPalette.gold,
            ),
            SizedBox(width: 9),
            Text(
              'ร้านค้าชุมชน',
              style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            final hasFilters =
                controller.searchQuery.value.isNotEmpty ||
                controller.selectedCategoryId.value != null ||
                controller.selectedDistrictId.value != null ||
                controller.onlyOpenNow.value;
            if (!hasFilters) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(
                  Icons.filter_alt_off_rounded,
                  size: 15,
                  color: ShopListPalette.gold,
                ),
                label: const Text(
                  'ล้างตัวกรอง',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final shops = controller.displayedShops;
        final showingList = controller.viewType.value == 'list';
        final loading = controller.isLoading.value;
        final featuredMode = controller.displayMode.value == 'grid'
            ? 'featured'
            : 'list';

        return RefreshIndicator(
          onRefresh: controller.refreshPage,
          color: ShopListPalette.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // 1. Header with search bar
              SliverToBoxAdapter(
                child: ShopListHeader(
                  searchController: searchController,
                  onSearchChanged: _onSearchChanged,
                ),
              ),

              // 2. Filter Controls (Tabs, Categories, District, Open Now)
              SliverToBoxAdapter(
                child: ShopListFilters(controller: controller),
              ),

              // 3. Main Content
              if (loading)
                const SliverFillRemaining(child: LoadingWidget())
              else if (!showingList)
                SliverFillRemaining(
                  child: ShopInteractiveMapView(shops: shops),
                )
              else if (shops.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _emptyState(),
                )
              else ...[
                // Featured / Highlight Shop Section
                SliverToBoxAdapter(
                  child: _sectionTitle(
                    title: 'ร้านค้าแนะนำ',
                    subtitle: 'คัดสรรร้านเด่นของชุมชน',
                    badge: '${shops.length} ร้านให้เลือก',
                    showToggle: true,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: ShopCard(
                      item: shops.first,
                      displayMode: featuredMode,
                    ),
                  ),
                ),

                // Special Deals / Flash Sale Section
                if (controller.specialProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: ShopFlashSaleSection(
                      products: controller.specialProducts,
                    ),
                  ),

                // Remaining Shops List
                if (shops.length > 1) ...[
                  SliverToBoxAdapter(
                    child: _sectionTitle(
                      title: 'สำรวจร้านค้าทั้งหมด',
                      subtitle: 'สินค้าและบริการจากคนในท้องถิ่น',
                      badge: '${shops.length - 1} ร้าน',
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ShopCard(item: shops[index + 1]),
                        ),
                        childCount: shops.length - 1,
                      ),
                    ),
                  ),
                ] else
                  const SliverToBoxAdapter(child: SizedBox(height: 36)),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ShopListPalette.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_outlined,
                size: 40,
                color: ShopListPalette.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ยังไม่พบร้านค้าที่ตรงกับการค้นหา',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ShopListPalette.ink,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'ลองค้นหาด้วยคำอื่น หรือล้างตัวกรองเพื่อดูร้านค้าทั้งหมด',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ShopListPalette.muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: ShopListPalette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'ล้างตัวกรองทั้งหมด',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    required String subtitle,
    required String badge,
    bool showToggle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ShopListPalette.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ShopListPalette.primarySoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: ShopListPalette.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: ShopListPalette.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (showToggle)
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: controller.toggleDisplayMode,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ShopListPalette.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.displayMode.value == 'grid'
                            ? Icons.view_agenda_outlined
                            : Icons.grid_view_rounded,
                        size: 16,
                        color: ShopListPalette.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        controller.displayMode.value == 'grid'
                            ? 'มุมมองการ์ด'
                            : 'มุมมองรายการ',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: ShopListPalette.inkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
