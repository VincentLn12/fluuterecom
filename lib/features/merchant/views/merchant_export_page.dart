import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/merchant_export_controller.dart';

class MerchantExportPage extends GetView<MerchantExportController> {
  const MerchantExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'ส่งออกรายงานร้านค้า (Export Reports)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Hero
            _buildHeroHeader(),

            const SizedBox(height: 20),

            // Section 1: Export Type Selection
            _buildSectionCard(
              title: '1. เลือกประเภทรายงานที่ต้องการส่งออก',
              icon: Icons.bar_chart_rounded,
              children: [
                Obx(() {
                  return Column(
                    children: controller.exportTypes.map((type) {
                      final val = type['value'] as String;
                      final isSelected =
                          controller.selectedExportType.value == val;
                      final icon = type['icon'] as IconData;
                      final color = type['color'] as Color;

                      return InkWell(
                        onTap: () => controller.selectedExportType.value = val,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.08)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color
                                      : const Color(0xFFE2E8F0),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type['title'] as String,
                                      style: GoogleFonts.krub(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? color
                                            : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      type['subtitle'] as String,
                                      style: GoogleFonts.krub(
                                        fontSize: 12,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: val,
                                groupValue: controller.selectedExportType.value,
                                activeColor: color,
                                onChanged: (v) {
                                  if (v != null) {
                                    controller.selectedExportType.value = v;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // Section 2: Date Range
            _buildSectionCard(
              title: '2. เลือกช่วงวันที่รายงาน',
              icon: Icons.date_range_rounded,
              children: [
                Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.datePresets.map((preset) {
                      final val = preset['value']!;
                      final isSelected = controller.datePreset.value == val;

                      return ChoiceChip(
                        label: Text(
                          preset['label']!,
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF475569),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF047857),
                        backgroundColor: const Color(0xFFF1F5F9),
                        side: BorderSide.none,
                        onSelected: (_) => controller.applyDatePreset(val),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => controller.selectDateRange(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Color(0xFF047857),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(() {
                                  final from = controller.formatDateString(
                                    controller.fromDate.value,
                                  );
                                  final to = controller.formatDateString(
                                    controller.toDate.value,
                                  );
                                  return Text(
                                    'ช่วงวันที่: $from ถึง $to',
                                    style: GoogleFonts.krub(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          color: Color(0xFF64748B),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Section 3: Format Choice
            _buildSectionCard(
              title: '3. เลือกรูปแบบไฟล์ (File Format)',
              icon: Icons.file_present_rounded,
              children: [
                Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildFormatOptionTile(
                          title: '📄 เอกสาร PDF',
                          subtitle: 'ตาราง A4 แนวนอน พิมพ์ง่าย',
                          value: 'pdf',
                          selectedValue: controller.selectedFormat.value,
                          color: const Color(0xFFE11D48),
                          onTap: () => controller.selectedFormat.value = 'pdf',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormatOptionTile(
                          title: '📊 ไฟล์ CSV',
                          subtitle: 'เปิดใน MS Excel (UTF-8)',
                          value: 'csv',
                          selectedValue: controller.selectedFormat.value,
                          color: const Color(0xFF059669),
                          onTap: () => controller.selectedFormat.value = 'csv',
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // Section 4: Extra Filters (Orders only)
            Obx(() {
              if (controller.selectedExportType.value != 'orders') {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildSectionCard(
                  title: '4. ตัวกรองเพิ่มเติมสำหรับออเดอร์ (Optional)',
                  icon: Icons.filter_alt_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สถานะการชำระเงิน',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  initialValue: controller.selectedPaymentStatus.value,
                                  isExpanded: true,
                                  decoration: _inputDecoration(),
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'All',
                                      child: Text('ทั้งหมด'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Paid',
                                      child: Text('ชำระแล้ว'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'PendingVerification',
                                      child: Text('รอตรวจสลิป'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Unpaid',
                                      child: Text('ยังไม่ชำระ'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      controller.selectedPaymentStatus.value = v;
                                    }
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สถานะออเดอร์',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  initialValue: controller.selectedOrderStatus.value,
                                  isExpanded: true,
                                  decoration: _inputDecoration(),
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'All',
                                      child: Text('ทั้งหมด'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Shipped',
                                      child: Text('จัดส่งแล้ว'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Completed',
                                      child: Text('สำเร็จ'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Cancelled',
                                      child: Text('ยกเลิก'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      controller.selectedOrderStatus.value = v;
                                    }
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            // Submit Download Button
            Obx(() {
              final isExporting = controller.isExporting.value;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isExporting ? null : controller.exportReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: isExporting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Icon(Icons.download_rounded, size: 22),
                  label: Text(
                    isExporting
                        ? 'กำลังเตรียมรายงาน...'
                        : 'ส่งออกและดาวน์โหลดรายงาน',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF047857),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ระบบส่งออกรายงานร้านค้า',
                  style: GoogleFonts.krub(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ดาวน์โหลดรายงานคำสั่งซื้อ ยอดขายสินค้า หรือประวัติการโอนเงินในรูปแบบ PDF หรือ CSV',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFF047857),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF047857), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFormatOptionTile({
    required String title,
    required String subtitle,
    required String value,
    required String selectedValue,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedValue == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
    );
  }
}
