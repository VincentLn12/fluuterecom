import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_section_card.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_input_decoration.dart';

class AdminExportFilters extends StatelessWidget {
  const AdminExportFilters({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          final type = controller.selectedExportType.value;
          if (type != 'orders' && type != 'payouts') {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: AdminExportSectionCard(
              stepNumber: '4',
              title: 'ตัวกรองเพิ่มเติมสำหรับรายงาน',
              icon: Icons.filter_alt_rounded,
              children: [
                if (type == 'orders')
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
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: controller.selectedPaymentStatus.value,
                              isExpanded: true,
                              decoration: AdminExportInputDecoration.build(),
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
                                  controller.selectedPaymentStatus.value = v;
                                }
                              },
                            ),
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
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: controller.selectedOrderStatus.value,
                              isExpanded: true,
                              decoration: AdminExportInputDecoration.build(),
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
                                  controller.selectedOrderStatus.value = v;
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
                        decoration: AdminExportInputDecoration.build(),
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
      ],
    );
  }
}
