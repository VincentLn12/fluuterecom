import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../../../shared/widgets/app_view_toggle.dart';
import '../controllers/content_controller.dart';

class ContentSearchHeader extends GetView<ContentController> {
  const ContentSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
