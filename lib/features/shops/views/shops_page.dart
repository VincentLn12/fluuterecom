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
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF332820),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFD96C2C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KANCHANABURI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFFE9C46A),
                  ),
                ),
                Text(
                  'ร้านค้า & สินค้าชุมชน OTOP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
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
        return Column(
          children: [
            // 1. HERO BANNER & SEARCH & VIEW TOGGLE
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B1F17), Color(0xFF3D2D23)],
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
                  const Text(
                    'ช้อปสินค้า OTOP & ร้านเด็ดเมืองกาญจน์ ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ของฝากขึ้นชื่อ ร้านอาหารริมน้ำ งานแฮนด์เมด และสินค้าเกษตรชุมชน',
                    style: TextStyle(color: Color(0xFFE8D9C9), fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  // Reusable Search Field
                  AppSearchField(
                    hintText: 'ค้นหาชื่อร้านค้า สินค้า หรือคำอธิบาย...',
                    onChanged: controller.setSearch,
                  ),
                  const SizedBox(height: 14),

                  // Reusable View Switcher Toggle
                  AppViewToggle<String>(
                    selectedValue: controller.viewType.value,
                    onChanged: controller.setViewType,
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

            // 2. CATEGORIES & DISTRICT FILTER ROW
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppCategoryChip(
                      label: 'ทั้งหมด',
                      isSelected: controller.selectedCategoryId.value == null,
                      onTap: () => controller.selectCategory(null),
                    ),
                    ...controller.categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AppCategoryChip(
                          label: cat.name,
                          isSelected:
                              controller.selectedCategoryId.value == cat.id,
                          onTap: () => controller.selectCategory(cat.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 16,
                    color: Color(0xFF332820),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'อำเภอ:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8D9C9)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: controller.selectedDistrictId.value,
                          hint: const Text(
                            'ทุกอำเภอ',
                            style: TextStyle(fontSize: 12),
                          ),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text(
                                'ทุกอำเภอในกาญจนบุรี',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            ...controller.districts.map(
                              (d) => DropdownMenuItem<String?>(
                                value: d.id,
                                child: Text(
                                  d.name,
                                  style: const TextStyle(fontSize: 12),
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

            // 3. MAIN CONTENT BODY (LIST VIEW vs MAP VIEW)
            Expanded(
              child: controller.isLoading.value
                  ? const LoadingWidget()
                  : controller.viewType.value == 'map'
                  ? ShopInteractiveMapView(shops: controller.shops)
                  : RefreshIndicator(
                      onRefresh: controller.fetchShops,
                      color: const Color(0xFFD96C2C),
                      child: controller.shops.isEmpty
                          ? EmptyWidget(
                              message:
                                  'ไม่พบข้อมูลร้านค้าตรงกับเงื่อนไขการค้นหา',
                            )
                          : controller.displayMode.value == 'grid'
                          ? ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.shops.length,
                              itemBuilder: (context, index) {
                                final item = controller.shops[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: ShopCard(
                                    item: item,
                                    displayMode: 'grid',
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.shops.length,
                              itemBuilder: (context, index) {
                                final item = controller.shops[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: ShopCard(
                                    item: item,
                                    displayMode: 'list',
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
