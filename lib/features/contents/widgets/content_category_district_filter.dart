import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/app_category_chip.dart';
import '../controllers/content_controller.dart';

class ContentCategoryDistrictFilter extends GetView<ContentController> {
  const ContentCategoryDistrictFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
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
                      isSelected: controller.selectedCategoryId.value == cat.id,
                      onTap: () => controller.selectCategory(cat.id),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }
}
