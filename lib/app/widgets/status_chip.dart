import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusChip({super.key, required this.label, this.color});

  static Color resolve(String value) {
    switch (value) {
      case 'vacant':
      case 'active':
      case 'paid':
      case 'completed':
        return AppTheme.success;
      case 'reserved':
      case 'pending':
      case 'medium':
        return AppTheme.warning;
      case 'maintenance':
      case 'overdue':
      case 'high':
      case 'cancelled':
        return AppTheme.danger;
      case 'in_progress':
      case 'occupied':
        return AppTheme.primary;
      default:
        return Colors.grey;
    }
  }

  static String translate(String value) {
    switch (value) {
      case 'vacant':
        return 'ว่าง';
      case 'occupied':
        return 'มีผู้เช่า';
      case 'reserved':
        return 'จอง';
      case 'maintenance':
        return 'ซ่อมบำรุง';
      case 'active':
        return 'กำลังเช่า';
      case 'inactive':
        return 'ย้ายออกแล้ว';
      case 'pending':
        return 'รอดำเนินการ';
      case 'paid':
        return 'ชำระแล้ว';
      case 'overdue':
        return 'ค้างชำระ';
      case 'in_progress':
        return 'กำลังดำเนินการ';
      case 'completed':
        return 'เสร็จสิ้น';
      case 'cancelled':
        return 'ยกเลิก';
      case 'low':
        return 'ต่ำ';
      case 'medium':
        return 'ปานกลาง';
      case 'high':
        return 'สูง';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? resolve(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: chipColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        translate(label),
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
