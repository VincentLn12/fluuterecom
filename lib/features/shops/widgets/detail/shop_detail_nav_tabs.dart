import 'package:flutter/material.dart';

class ShopTabItem {
  final int id;
  final String label;
  final IconData icon;
  final int? count;

  const ShopTabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.count,
  });
}

class ShopDetailNavTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;
  final int productCount;
  final int contentCount;
  final int reviewCount;

  const ShopDetailNavTabs({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
    required this.productCount,
    required this.contentCount,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final List<ShopTabItem> tabs = [
      const ShopTabItem(
        id: 0,
        label: 'หน้าแรก',
        icon: Icons.grid_view_rounded,
      ),
      ShopTabItem(
        id: 1,
        label: 'สินค้า',
        icon: Icons.shopping_bag_outlined,
        count: productCount,
      ),
      if (contentCount > 0)
        ShopTabItem(
          id: 2,
          label: 'เรื่องราว',
          icon: Icons.article_outlined,
          count: contentCount,
        ),
      const ShopTabItem(
        id: 3,
        label: 'เกี่ยวกับ',
        icon: Icons.info_outline_rounded,
      ),
      ShopTabItem(
        id: 4,
        label: 'รีวิว',
        icon: Icons.star_outline_rounded,
        count: reviewCount,
      ),
    ];

    return Container(
      height: 46,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5ECE8), width: 1),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 22),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = activeIndex == tab.id;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTabSelected(tab.id),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 17,
                      color: isSelected
                          ? const Color(0xFF2A9D8F)
                          : const Color(0xFF7A938B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0D2B22)
                            : const Color(0xFF7A938B),
                      ),
                    ),
                    if (tab.count != null && tab.count! > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2A9D8F)
                              : const Color(0xFFEEF4F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${tab.count}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF5A7B70),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // Active Underline Indicator Bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 3,
                  width: isSelected ? 34 : 0,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2A9D8F)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
