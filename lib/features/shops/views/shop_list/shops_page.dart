import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_card.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_flash_sale_section.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/shop_interactive_map_view.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/shared/widgets/empty_widget.dart';
import 'package:projecte/shared/widgets/app_search_field.dart';
import 'package:projecte/shared/widgets/app_category_chip.dart';
import 'package:projecte/shared/widgets/app_view_toggle.dart';

class ShopsPage extends GetView<ShopController> {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7F4),
        foregroundColor: const Color(0xFF173D32),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE2F0E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 20,
                color: Color(0xFF26734D),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ร้านค้า & สินค้าชุมชน',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF173D32),
                    ),
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
                      color: const Color(0xFF26734D),
                    ),
                    onPressed: controller.toggleDisplayMode,
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(
            tooltip: 'ล้างตัวกรอง',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: controller.clearFilters,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        final displayedShops = controller.displayedShops;

        return RefreshIndicator(
          onRefresh: controller.refreshPage,
          color: const Color(0xFF26734D),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. HERO MARKETPLACE BILLBOARD & SEARCH BAR
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF174936), Color(0xFF26734D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF174936).withValues(alpha: 0.15),
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ของดีจากร้านท้องถิ่น',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'ค้นหาร้านค้าและสินค้าชุมชนในกาญจนบุรี',
                        style: TextStyle(
                          color: Color(0xFFD5E8DC),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 13),
                      AppSearchField(
                        hintText: 'ค้นหาร้านค้า สินค้า OTOP หรือของฝาก...',
                        onChanged: controller.setSearch,
                        iconColor: const Color(0xFF26734D),
                      ),
                      const SizedBox(height: 12),
                      AppViewToggle<String>(
                        selectedValue: controller.viewType.value,
                        onChanged: controller.setViewType,
                        activeColor: const Color(0xFF65A878),
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
                child: Container(
                  margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE4ECE6)),
                  ),
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
                                        ? const Color(0xFF26734D)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: controller.onlyOpenNow.value
                                          ? const Color(0xFF26734D)
                                          : const Color(0xFFE0EAE6),
                                      width: 1.2,
                                    ),
                                    boxShadow: controller.onlyOpenNow.value
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF26734D,
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
                                              : const Color(0xFF26734D),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'เปิดอยู่ตอนนี้',
                                        style: TextStyle(
                                          color: controller.onlyOpenNow.value
                                              ? Colors.white
                                              : const Color(0xFF284A39),
                                          fontWeight:
                                              controller.onlyOpenNow.value
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
                                selectedColor: const Color(0xFF26734D),
                                isSelected:
                                    controller.selectedCategoryId.value == null,
                                onTap: () => controller.selectCategory(null),
                              ),
                              ...controller.categories.map((cat) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: AppCategoryChip(
                                    label: cat.name,
                                    selectedColor: const Color(0xFF26734D),
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
                              color: Color(0xFF284A39),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'อำเภอ:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF284A39),
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
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
              ),

              if (controller.viewType.value == 'list' &&
                  controller.specialProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: ShopFlashSaleSection(
                    products: controller.specialProducts,
                  ),
                ),

              if (controller.viewType.value == 'list' &&
                  !controller.isLoading.value &&
                  displayedShops.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storefront_rounded,
                          size: 18,
                          color: Color(0xFF26734D),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'ร้านค้าชุมชน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF244637),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${displayedShops.length} ร้าน',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718078),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
