import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_controller.dart';
import '../widgets/content_card.dart';
import '../widgets/content_interactive_map_view.dart';
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
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFFE9C46A),
                  ),
                ),
                Text(
                  'เนื้อหา & บทความท่องเที่ยว',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          Obx(
            () => _AnimatedRefreshButton(
              onPressed: controller.clearFilters,
              isLoading: controller.isLoading.value,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _TravelCenterLoadingWidget();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchContents,
          color: const Color(0xFFD96C2C),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. HERO SEARCH BANNER & VIEW TYPE TOGGLE (Scrolls away naturally)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
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
                        'ค้นพบเรื่องราวเมืองกาญจน์ ✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'แหล่งท่องเที่ยว ประวัติศาสตร์ คาเฟ่เด็ด และวิถีชีวิตท้องถิ่น',
                        style: TextStyle(
                          color: Color(0xFFE8D9C9),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Reusable Search Field
                      AppSearchField(
                        hintText: 'ค้นหาบทความ สถานที่ หรือคีย์เวิร์ด...',
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
              ),

              // 2. CATEGORIES & DISTRICT FILTER ROW (Scrolls away naturally)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            AppCategoryChip(
                              label: 'ทั้งหมด',
                              isSelected:
                                  controller.selectedCategoryId.value == null,
                              onTap: () => controller.selectCategory(null),
                            ),
                            ...controller.categories.map((cat) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AppCategoryChip(
                                  label: cat.name,
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
                            color: Color(0xFF332820),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'อำเภอ:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF332820),
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
                                  color: const Color(0xFFE8D9C9),
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

              // 3. MAIN CONTENT BODY (1 CARD PER ROW GRID vs COMPACT LIST vs MAP)
              if (controller.viewType.value == 'map')
                SliverFillRemaining(
                  child: ContentInteractiveMapView(
                    contents: controller.contents,
                  ),
                )
              else if (controller.contents.isEmpty)
                const SliverFillRemaining(
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

/// A cool travel-themed center-screen loading widget featuring a rotating compass sweep ring
/// and a pulsing travel explore badge with custom typography.
class _TravelCenterLoadingWidget extends StatefulWidget {
  const _TravelCenterLoadingWidget();

  @override
  State<_TravelCenterLoadingWidget> createState() =>
      __TravelCenterLoadingWidgetState();
}

class __TravelCenterLoadingWidgetState extends State<_TravelCenterLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Compass Ring Spinning
              RotationTransition(
                turns: _spinController,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFFD96C2C).withValues(alpha: 0.1),
                        const Color(0xFFD96C2C),
                        const Color(0xFFE9C46A),
                        const Color(0xFFD96C2C).withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7F0E6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Inner Pulsing Travel Explore Badge Icon
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD96C2C), Color(0xFFC45A1B)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD96C2C).withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Cool Travel Loading Text
          const Text(
            'กำลังสำรวจเรื่องราวเมืองกาญจน์...',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF332820),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ค้นหาบทความ & สถานที่แนะนำ',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _AnimatedRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _AnimatedRefreshButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<_AnimatedRefreshButton> createState() => _AnimatedRefreshButtonState();
}

class _AnimatedRefreshButtonState extends State<_AnimatedRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'ล้างตัวกรอง / รีโหลด',
      icon: RotationTransition(
        turns: _controller,
        child: const Icon(Icons.refresh_rounded, color: Colors.white),
      ),
      onPressed: _handleTap,
    );
  }
}
