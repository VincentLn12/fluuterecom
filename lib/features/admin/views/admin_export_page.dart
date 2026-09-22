import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_export_controller.dart';

class AdminExportPage extends GetView<AdminExportController> {
  const AdminExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminExportController>()) {
      Get.put(AdminExportController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'รายงานและดาวน์โหลด (Admin Exports)',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2D25), Color(0xFF1B4D3E), Color(0xFF2A9D8F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Hero Banner
            _buildHeroHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Export Type Selection
                  _buildSectionCard(
                    stepNumber: '1',
                    title: 'เลือกประเภทรายงานที่ต้องการส่งออก',
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
                              onTap: () =>
                                  controller.selectedExportType.value = val,
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.06)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : const Color(0xFFCBD5E1),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            type['title'] as String,
                                            style: GoogleFonts.krub(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? color
                                                  : const Color(0xFF0F172A),
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
                                    const SizedBox(width: 8),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? color
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? color
                                              : const Color(0xFF94A3B8),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.white, size: 16)
                                          : null,
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

                  // Step 2: Date Range
                  _buildSectionCard(
                    stepNumber: '2',
                    title: 'เลือกช่วงวันที่รายงาน',
                    icon: Icons.date_range_rounded,
                    children: [
                      Obx(() {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.datePresets.map((preset) {
                            final val = preset['value']!;
                            final isSelected =
                                controller.datePreset.value == val;

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
                                      : const Color(0xFF334155),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              backgroundColor: const Color(0xFFF1F5F9),
                              side: BorderSide.none,
                              onSelected: (_) =>
                                  controller.applyDatePreset(val),
                            );
                          }).toList(),
                        );
                      }),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => controller.selectDateRange(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(() {
                                        final from = controller.formatDateString(
                                            controller.fromDate.value);
                                        final to = controller.formatDateString(
                                            controller.toDate.value);
                                        return Text(
                                          'ช่วงวันที่: $from ถึง $to',
                                          style: GoogleFonts.krub(
                                            fontSize: 14,
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
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Step 3: Format Choice
                  _buildSectionCard(
                    stepNumber: '3',
                    title: 'เลือกรูปแบบไฟล์ (File Format)',
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
                                icon: Icons.picture_as_pdf_rounded,
                                onTap: () =>
                                    controller.selectedFormat.value = 'pdf',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFormatOptionTile(
                                title: '📊 ไฟล์ CSV',
                                subtitle: 'นำไปเปิดใน MS Excel (UTF-8)',
                                value: 'csv',
                                selectedValue: controller.selectedFormat.value,
                                color: const Color(0xFF059669),
                                icon: Icons.table_chart_rounded,
                                onTap: () =>
                                    controller.selectedFormat.value = 'csv',
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Step 4: Conditional Extra Filters
                  Obx(() {
                    final type = controller.selectedExportType.value;
                    if (type != 'orders' && type != 'payouts') {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildSectionCard(
                        stepNumber: '4',
                        title: 'ตัวกรองเพิ่มเติมสำหรับรายงาน',
                        icon: Icons.filter_alt_rounded,
                        children: [
                          if (type == 'orders')
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'สถานะการชำระเงิน',
                                        style: GoogleFonts.krub(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: controller
                                            .selectedPaymentStatus.value,
                                        isExpanded: true,
                                        decoration: _inputDecoration(),
                                        style: GoogleFonts.krub(
                                          fontSize: 13,
                                          color: const Color(0xFF0F172A),
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
                                            controller.selectedPaymentStatus
                                                .value = v;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'สถานะออเดอร์',
                                        style: GoogleFonts.krub(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: controller
                                            .selectedOrderStatus.value,
                                        isExpanded: true,
                                        decoration: _inputDecoration(),
                                        style: GoogleFonts.krub(
                                          fontSize: 13,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'All',
                                            child: Text('ทั้งหมด'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'PendingPayment',
                                            child: Text('รอชำระเงิน'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'PendingVerification',
                                            child: Text('รอยืนยันสลิป'),
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
                                            controller.selectedOrderStatus
                                                .value = v;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (type == 'payouts')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'สถานะการโอนเงินร้านค้า',
                                  style: GoogleFonts.krub(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: controller.selectedPayoutStatus.value,
                                  isExpanded: true,
                                  decoration: _inputDecoration(),
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'All',
                                      child: Text('ทั้งหมด'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Pending',
                                      child: Text('รอนุมัติโอน'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Processing',
                                      child: Text('กำลังดำเนินการโอน'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Completed',
                                      child: Text('โอนเงินสำเร็จ'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Failed',
                                      child: Text('โอนเงินไม่สำเร็จ'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      controller.selectedPayoutStatus.value = v;
                                    }
                                  },
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
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
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
                            : const Icon(Icons.file_download_rounded, size: 24),
                        label: Text(
                          isExporting
                              ? 'กำลังเตรียมและออกรายงาน...'
                              : 'ดาวน์โหลดรายงานการส่งออก',
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2D25), Color(0xFF1B4D3E), Color(0xFF2A9D8F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.amberAccent,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ศูนย์ดาวน์โหลดรายงานสำหรับแอดมิน',
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ส่งออกรายงานยอดขาย รายการออเดอร์ ประวัติโอนเงิน และผลตรวจสลิป เป็นไฟล์ PDF หรือ CSV ได้ทันที',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.35,
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
    required String stepNumber,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: AppColors.primaryDark, size: 20),
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
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
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
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedValue == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFCBD5E1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 18,
                    color: isSelected ? color : const Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.krub(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
    );
  }
}
