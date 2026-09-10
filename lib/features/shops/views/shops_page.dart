import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';
import '../widgets/shop_card.dart';
import '../widgets/shop_interactive_map_view.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../../../shared/widgets/app_category_chip.dart';
import '../../../shared/widgets/app_view_toggle.dart';

class ShopsPage extends GetView<ShopController> {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F382C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE76F51).withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KANCHANABURI BAZAAR',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFE9C46A),
                    ),
                  ),
                  Text(
                    'ร้านค้า & สินค้าชุมชน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => controller.viewType.value == 'list'
                ? IconButton(
                    tooltip: 'เปลี่ยนมุมมองการ์ด',
                    icon: Icon(
                      controller.displayMode.value == 'grid'
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      color: Colors.white,
                    ),
                    onPressed: controller.toggleDisplayMode,
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(
            tooltip: 'ล้างตัวกรอง',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: controller.clearFilters,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        final displayedShops = controller.displayedShops;

        return RefreshIndicator(
          onRefresh: controller.fetchShops,
          color: const Color(0xFF2A9D8F),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. HERO MARKETPLACE BILLBOARD & SEARCH BAR
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F382C), Color(0xFF1B4D3E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Input
                      AppSearchField(
                        hintText: 'ค้นหาชื่อร้านค้า สินค้า OTOP หรือของฝาก...',
                        onChanged: controller.setSearch,
                        iconColor: const Color(0xFF2A9D8F),
                      ),
                      const SizedBox(height: 14),

                      // View Type Switcher Toggle
                      AppViewToggle<String>(
                        selectedValue: controller.viewType.value,
                        onChanged: controller.setViewType,
                        activeColor: const Color(0xFF2A9D8F),
                        options: const [
                          ToggleOption(
                            value: 'list',
                            label: 'รายการร้านค้า',
                            icon: Icons.storefront_rounded,
                          ),
                          ToggleOption(
                            value: 'map',
                            label: 'แผนที่ร้านค้า',
                            icon: Icons.map_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. QUICK FILTER BUTTONS & CATEGORIES & DISTRICTS
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Quick Filter Pill: 🟢 เปิดอยู่ตอนนี้
                            GestureDetector(
                              onTap: controller.toggleOnlyOpenNow,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8.5,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.onlyOpenNow.value
                                      ? const Color(0xFF2A9D8F)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: controller.onlyOpenNow.value
                                        ? const Color(0xFF2A9D8F)
                                        : const Color(0xFFE0EAE6),
                                    width: 1.2,
                                  ),
                                  boxShadow: controller.onlyOpenNow.value
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF2A9D8F,
                                            ).withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.03,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: controller.onlyOpenNow.value
                                            ? Colors.white
                                            : const Color(0xFF2A9D8F),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'เปิดอยู่ตอนนี้',
                                      style: TextStyle(
                                        color: controller.onlyOpenNow.value
                                            ? Colors.white
                                            : const Color(0xFF0D2B22),
                                        fontWeight: controller.onlyOpenNow.value
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Category Chips
                            AppCategoryChip(
                              label: 'ทั้งหมด',
                              selectedColor: const Color(0xFF2A9D8F),
                              isSelected:
                                  controller.selectedCategoryId.value == null,
                              onTap: () => controller.selectCategory(null),
                            ),
                            ...controller.categories.map((cat) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AppCategoryChip(
                                  label: cat.name,
                                  selectedColor: const Color(0xFF2A9D8F),
                                  isSelected:
                                      controller.selectedCategoryId.value ==
                                      cat.id,
                                  onTap: () =>
                                      controller.selectCategory(cat.id),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    // District Filter Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_alt_outlined,
                            size: 18,
                            color: Color(0xFF0D2B22),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'อำเภอ:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0D2B22),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE0EAE6),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                  value: controller.selectedDistrictId.value,
                                  hint: const Text(
                                    'ทุกอำเภอ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  isExpanded: true,
                                  items: [
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text(
                                        'ทุกอำเภอในกาญจนบุรี',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    ...controller.districts.map(
                                      (d) => DropdownMenuItem<String?>(
                                        value: d.id,
                                        child: Text(
                                          d.name,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: controller.selectDistrict,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              // 3. MAIN CONTENT BODY (GRID vs LIST vs MAP)
              if (controller.isLoading.value)
                const SliverFillRemaining(child: LoadingWidget())
              else if (controller.viewType.value == 'map')
                SliverFillRemaining(
                  child: ShopInteractiveMapView(shops: displayedShops),
                )
              else if (displayedShops.isEmpty)
                const SliverFillRemaining(
                  child: EmptyWidget(
                    message: 'ไม่พบข้อมูลร้านค้าตรงกับเงื่อนไขที่เลือก',
                  ),
                )
              else if (controller.displayMode.value == 'grid')
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = displayedShops[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ShopCard(item: item, displayMode: 'grid'),
                      );
                    }, childCount: displayedShops.length),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = displayedShops[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ShopCard(item: item, displayMode: 'list'),
                      );
                    }, childCount: displayedShops.length),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
