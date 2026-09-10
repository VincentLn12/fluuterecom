import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/content_controller.dart';
import '../widgets/content_card.dart';
import '../widgets/content_category_district_filter.dart';
import '../widgets/content_interactive_map_view.dart';
import '../widgets/content_refresh_button.dart';
import '../widgets/content_search_header.dart';

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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KANCHANABURI',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFE9C46A),
                    ),
                  ),
                  Text(
                    'เนื้อหา & บทความท่องเที่ยว',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
          Obx(
            () => ContentRefreshButton(
              onPressed: controller.clearFilters,
              isLoading: controller.isLoading.value,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(
            message: 'กำลังสำรวจเรื่องราวเมืองกาญจน์...',
            subMessage: 'ค้นหาบทความ & สถานที่แนะนำ',
            icon: Icons.explore_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchContents,
          color: const Color(0xFFD96C2C),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: ContentSearchHeader()),

              const SliverToBoxAdapter(child: ContentCategoryDistrictFilter()),

              if (controller.viewType.value == 'map')
                SliverFillRemaining(
                  child: ContentInteractiveMapView(
                    contents: controller.contents,
                  ),
                )
              else if (controller.contents.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyWidget(
                    message: 'ไม่พบข้อมูลคอนเทนต์ตรงกับเงื่อนไขการค้นหา',
                  ),
                )
              else if (controller.displayMode.value == 'grid')
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = controller.contents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ContentCard(
                          item: item,
                          displayMode: 'grid',
                          index: index,
                        ),
                      );
                    }, childCount: controller.contents.length),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = controller.contents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ContentCard(
                          item: item,
                          displayMode: 'list',
                          index: index,
                        ),
                      );
                    }, childCount: controller.contents.length),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
