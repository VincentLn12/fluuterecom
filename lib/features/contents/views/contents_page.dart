import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_controller.dart';
import '../widgets/content_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_widget.dart';

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
            () => IconButton(
              tooltip: 'เปลี่ยนมุมมอง',
              icon: Icon(
                controller.displayMode.value == 'grid'
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                color: Colors.white,
              ),
              onPressed: controller.toggleDisplayMode,
            ),
          ),
          IconButton(
            tooltip: 'ล้างตัวกรอง',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: controller.clearFilters,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchContents,
        color: const Color(0xFFD96C2C),
        child: CustomScrollView(
          slivers: [
            // 1. HERO SEARCH BANNER
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
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
                    const Text(
                      'ค้นพบเรื่องราวเมืองกาญจน์',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'แหล่งท่องเที่ยว ประวัติศาสตร์ คาเฟ่เด็ด และวิถีชีวิตท้องถิ่น',
                      style: TextStyle(color: Color(0xFFE8D9C9), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: controller.setSearch,
                      style: const TextStyle(color: Color(0xFF332820)),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาชื่อบทความ สถานที่ หรือคีย์เวิร์ด...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFD96C2C),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. CATEGORY PILLS BAR
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(
                          label: 'ทั้งหมด',
                          isSelected:
                              controller.selectedCategoryId.value == null,
                          onTap: () => controller.selectCategory(null),
                        ),
                        ...controller.categories.map((cat) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: _buildCategoryChip(
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
              ),
            ),

            // 3. DISTRICT FILTER ROW
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      size: 18,
                      color: Color(0xFF332820),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'กรองตามอำเภอ:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8D9C9)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: controller.selectedDistrictId.value,
                              hint: const Text(
                                'ทุกอำเภอ',
                                style: TextStyle(fontSize: 13),
                              ),
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(
                                    'ทุกอำเภอในกาญจนบุรี',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                ...controller.districts.map(
                                  (d) => DropdownMenuItem<String?>(
                                    value: d.id,
                                    child: Text(
                                      d.name,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: controller.selectDistrict,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. CONTENT LIST / GRID CONTENT
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: Obx(() {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(child: LoadingWidget());
                }

                if (controller.contents.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyWidget(
                      message: 'ไม่พบข้อมูลคอนเทนต์ตรงกับเงื่อนไขการค้นหา',
                    ),
                  );
                }

                if (controller.displayMode.value == 'grid') {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              1, // Single column on phone for rich cards
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.05,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = controller.contents[index];
                      return ContentCard(item: item, displayMode: 'grid');
                    }, childCount: controller.contents.length),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = controller.contents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ContentCard(item: item, displayMode: 'list'),
                    );
                  }, childCount: controller.contents.length),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFD96C2C),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE8D9C9)),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF332820),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
