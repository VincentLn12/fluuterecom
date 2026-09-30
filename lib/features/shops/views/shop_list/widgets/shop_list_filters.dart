import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/controllers/shop_controller.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';

class ShopListFilters extends StatelessWidget {
  const ShopListFilters({super.key, required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. View Type Switcher (ร้านค้า / แผนที่)
          Container(
            height: 52,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ShopListPalette.line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x060D2B22),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Obx(
              () => Row(
                children: [
                  _viewTab(
                    'list',
                    Icons.storefront_rounded,
                    'รายการร้านค้า',
                  ),
                  _viewTab(
                    'map',
                    Icons.map_rounded,
                    'แผนที่ชุมชน',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Categories Horizontal Scrollable Chips
          Obx(
            () => SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _categoryChip(
                    label: 'ทั้งหมด',
                    icon: Icons.grid_view_rounded,
                    selected: controller.selectedCategoryId.value == null,
                    onTap: () => controller.selectCategory(null),
                  ),
                  ...controller.categories.map(
                    (category) => _categoryChip(
                      label: category.name,
                      selected:
                          controller.selectedCategoryId.value == category.id,
                      onTap: () => controller.selectCategory(category.id),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. District Picker & Open Now Filter Bar
          Row(
            children: [
              // District dropdown selector
              Expanded(
                child: Obx(() => _districtPicker()),
              ),
              const SizedBox(width: 10),
              // Only open now toggle button
              Obx(() => _openNowChip()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewTab(String value, IconData icon, String label) {
    final selected = controller.viewType.value == value;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setViewType(value),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [
                        ShopListPalette.primaryDark,
                        ShopListPalette.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: ShopListPalette.primary.withValues(alpha: 0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: selected ? Colors.white : ShopListPalette.muted,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? Colors.white : ShopListPalette.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    IconData? icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [
                        ShopListPalette.primaryDark,
                        ShopListPalette.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? Colors.transparent : ShopListPalette.line,
                width: 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: ShopListPalette.primary.withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: Color(0x040D2B22),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 17,
                    color: selected ? Colors.white : ShopListPalette.muted,
                  ),
                  const SizedBox(width: 7),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : ShopListPalette.inkSecondary,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _districtPicker() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: controller.selectedDistrictId.value != null
              ? ShopListPalette.primaryLight
              : ShopListPalette.line,
          width: controller.selectedDistrictId.value != null ? 1.4 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050D2B22),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 20,
            color: ShopListPalette.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: controller.selectedDistrictId.value,
                isExpanded: true,
                isDense: true,
                borderRadius: BorderRadius.circular(14),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ShopListPalette.muted,
                  size: 22,
                ),
                hint: const Text(
                  'ทุกอำเภอ',
                  style: TextStyle(
                    color: ShopListPalette.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: const TextStyle(
                  color: ShopListPalette.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('ทุกอำเภอ'),
                  ),
                  ...controller.districts.map(
                    (district) => DropdownMenuItem<String?>(
                      value: district.id,
                      child: Text(
                        'อ.${district.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: controller.selectDistrict,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _openNowChip() {
    final selected = controller.onlyOpenNow.value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.toggleOnlyOpenNow,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? ShopListPalette.greenSoft : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? ShopListPalette.green : ShopListPalette.line,
              width: selected ? 1.3 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050D2B22),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? ShopListPalette.green : ShopListPalette.mutedLight,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: ShopListPalette.green.withValues(alpha: 0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'เปิดอยู่ตอนนี้',
                style: TextStyle(
                  color: selected ? ShopListPalette.ink : ShopListPalette.muted,
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
