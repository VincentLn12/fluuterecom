import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../controllers/bill_controller.dart';
import '../../models/bill_model.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/status_chip.dart';

class BillDetailView extends StatelessWidget {
  const BillDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillController>();
    final routeBill = ModalRoute.of(context)!.settings.arguments as BillModel;
    final bill = controller.resolveCurrentBill(routeBill);
    final room = controller.rooms.firstWhereOrNull(
      (item) => item.id == bill.roomId,
    );
    final tenant = controller.tenants.firstWhereOrNull(
      (item) => item.id == bill.tenantId,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('ใบแจ้งหนี้ / ใบเสร็จ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            // Invoice container designed to look like a paper bill
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Invoice Header Accent Bar
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: bill.isPaid ? AppTheme.success : AppTheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo & Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'HorPak Space',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ใบแจ้งหนี้ / ใบเสร็จรับเงิน',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusChip(label: bill.status),
                          ],
                        ),

                        const Divider(height: 32),

                        // Bill Info Grid
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoLabel('ผู้เช่า / Tenant'),
                                  _buildInfoValue(
                                    tenant?.fullName ?? 'ไม่พบชื่อผู้เช่า',
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoLabel(
                                    'บิลประจำเดือน / Billing Month',
                                  ),
                                  _buildInfoValue(
                                    DateFormatter.formatBillingMonth(
                                      bill.billingMonth,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoLabel('หมายเลขห้อง / Room'),
                                  _buildInfoValue(
                                    'ห้อง ${room?.roomNumber ?? bill.roomId}',
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoLabel('กำหนดชำระ / Due Date'),
                                  _buildInfoValue(
                                    bill.dueDate,
                                    color: AppTheme.danger,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Decorative dashed line representing a receipt tear-off
                        Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Items Table Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'รายการ / Description',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'จำนวนเงิน / Amount',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),

                        // Item Rows
                        _buildInvoiceItem(
                          'ค่าเช่าห้องพัก (Room Rent)',
                          bill.roomRent,
                        ),
                        _buildInvoiceItem(
                          'ค่าน้ำประปา (Water Utility)',
                          bill.waterAmount,
                        ),
                        _buildInvoiceItem(
                          'ค่าไฟฟ้า (Electricity Utility)',
                          bill.electricAmount,
                        ),
                        _buildInvoiceItem(
                          'ค่าบริการอื่น ๆ (Others)',
                          bill.otherAmount,
                        ),
                        if (bill.lateFee > 0)
                          _buildInvoiceItem(
                            'ค่าปรับชำระล่าช้า (Late Fee)',
                            bill.lateFee,
                            isNegative: false,
                          ),

                        const SizedBox(height: 8),

                        // Total Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ยอดรวมทั้งสิ้น / Total Amount',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(bill.totalAmount),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Payment Details Section
                        if (bill.isPaid) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.success.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.success,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'ชำระเงินเรียบร้อยแล้ว / PAID',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.success.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                _buildPayDetailRow(
                                  'วันที่ชำระเงิน / Paid Date',
                                  bill.paidDate ?? '-',
                                ),
                                const SizedBox(height: 4),
                                _buildPayDetailRow(
                                  'ช่องทางชำระเงิน / Method',
                                  _translateMethod(bill.paymentMethod),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.danger.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.danger.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.danger,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ค้างชำระ / PENDING PAYMENT',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.danger,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'โปรดติดต่อผู้ดูแลหอพักหรือชำระเงินผ่านช่องทางที่กำหนด',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInfoValue(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(
    String title,
    double amount, {
    bool isNegative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          Text(
            (isNegative ? '-' : '') + CurrencyFormatter.format(amount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _translateMethod(String? method) {
    if (method == null) return '-';
    switch (method) {
      case 'cash':
        return 'เงินสด (Cash)';
      case 'bank_transfer':
        return 'โอนเงินผ่านธนาคาร (Bank Transfer)';
      case 'promptpay':
        return 'พร้อมเพย์ (PromptPay)';
      default:
        return method;
    }
  }
}
