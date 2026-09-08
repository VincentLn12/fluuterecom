import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_controller.dart';
import '../widgets/content_card.dart';
import '../widgets/content_interactive_map_view.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../../../shared/widgets/app_category_chip.dart';
import '../../../shared/widgets/app_view_toggle.dart';

class ContentsPage extends GetView<ContentController> {
  const ContentsPage({super.key});

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
              child: const Icon(Icons.explore, size: 20, color: Colors.white),
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
                  'เนื้อหา & บทความท่องเที่ยว',
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
            // 1. HERO SEARCH BANNER & VIEW TYPE TOGGLE
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF332820),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reusable Search Field
                  AppSearchField(
                    hintText: 'ค้นหาชื่อบทความ สถานที่ หรือคีย์เวิร์ด...',
                    onChanged: controller.setSearch,
                  ),
                  const SizedBox(height: 12),

                  // Reusable View Switcher Toggle
                  AppViewToggle<String>(
                    selectedValue: controller.viewType.value,
                    onChanged: controller.setViewType,
                    options: const [
                      ToggleOption(
                        value: 'list',
                        label: 'รายการบทความ',
                        icon: Icons.format_list_bulleted_rounded,
                      ),
                      ToggleOption(
                        value: 'map',
                        label: 'แผนที่ท่องเที่ยว',
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
                  ? ContentInteractiveMapView(contents: controller.contents)
                  : RefreshIndicator(
                      onRefresh: controller.fetchContents,
                      color: const Color(0xFFD96C2C),
                      child: controller.contents.isEmpty
                          ? EmptyWidget(
                              message:
                                  'ไม่พบข้อมูลคอนเทนต์ตรงกับเงื่อนไขการค้นหา',
                            )
                          : controller.displayMode.value == 'grid'
                          ? ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.contents.length,
                              itemBuilder: (context, index) {
                                final item = controller.contents[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: ContentCard(
                                    item: item,
                                    displayMode: 'grid',
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.contents.length,
                              itemBuilder: (context, index) {
                                final item = controller.contents[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: ContentCard(
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
