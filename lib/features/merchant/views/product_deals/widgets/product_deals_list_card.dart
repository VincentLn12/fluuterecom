import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDealsListCard extends StatelessWidget {
  const ProductDealsListCard({
    super.key,
    required this.deals,
    required this.onStopDeal,
  });

  final List<dynamic> deals;
  final ValueChanged<String> onStopDeal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFE65100),
              ),
              const SizedBox(width: 8),
              Text(
                'ดีลของสินค้านี้',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          if (deals.isEmpty)
            Text(
              'ยังไม่มีโปรโมชัน',
              style: GoogleFonts.krub(color: const Color(0xFF64748B)),
            )
          else
            ...deals.map((deal) {
              final active =
                  deal.status.toLowerCase() == 'active' && !deal.isExpired;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${deal.label} • ลด ${deal.discountValue}${deal.discountType == 'Percent' ? '%' : ' บาท'}',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${active ? 'กำลังใช้งาน' : _statusLabel(deal.status)} • ใช้แล้ว ${deal.usedQuantity}/${deal.totalQuantity} • สิ้นสุด ${_thaiDate(deal.endsAt)}',
                  style: GoogleFonts.krub(fontSize: 11),
                ),
                trailing: active
                    ? TextButton(
                        onPressed: () => onStopDeal(deal.id ?? ''),
                        child: const Text('หยุดดีล'),
                      )
                    : null,
              );
            }),
        ],
      ),
    );
  }

  String _thaiDate(DateTime? value) {
    if (value == null) return '-';
    final thai = value.toUtc().add(const Duration(hours: 7));
    return '${thai.day}/${thai.month}/${thai.year + 543} ${thai.hour.toString().padLeft(2, '0')}:${thai.minute.toString().padLeft(2, '0')} น.';
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'กำลังใช้งาน';
      case 'stopped':
        return 'หยุดแล้ว';
      case 'expired':
        return 'หมดเวลาแล้ว';
      default:
        return status;
    }
  }
}
