import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';

class ManageProductPromotionSheet {
  const ManageProductPromotionSheet._();

  Future<void> show(BuildContext context, ProductModel product) async {
    final repository = MerchantRepository();
    var deals = await repository.fetchProductDeals(product.id);
    if (!context.mounted) return;
    final discountController = TextEditingController();
    final quantityController = TextEditingController(
      text: product.quantity.toString(),
    );
    var dealType = 'FlashDeal';
    var discountType = 'Percent';
    var startsAt = DateTime.now().toUtc();
    var endsAt = startsAt.add(const Duration(days: 1));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) {
          final activeDeals = deals
              .where(
                (deal) =>
                    deal.status.toLowerCase() == 'active' && !deal.isExpired,
              )
              .toList();
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'โปรโมชัน: ${product.name}',
                    style: GoogleFonts.krub(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (deals.isNotEmpty) ...[
                    Text(
                      'ดีลของสินค้านี้',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                    ),
                    ...deals.map(
                      (deal) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${deal.label} • ลด ${deal.discountValue}${deal.discountType == 'Percent' ? '%' : ' บาท'}',
                        ),
                        subtitle: Text(
                          '${deal.status} • ใช้แล้ว ${deal.usedQuantity}/${deal.totalQuantity} • สิ้นสุด ${_thaiDate(deal.endsAt)}',
                        ),
                        trailing: deal.status.toLowerCase() == 'active'
                            ? TextButton(
                                onPressed: () async {
                                  final ok = await repository.stopProductDeal(
                                    deal.id ?? '',
                                  );
                                  if (ok) {
                                    deals = await repository.fetchProductDeals(
                                      product.id,
                                    );
                                    setState(() {});
                                  }
                                },
                                child: const Text('หยุดดีล'),
                              )
                            : null,
                      ),
                    ),
                    const Divider(),
                  ],
                  Text(
                    'สร้างโปรโมชันใหม่',
                    style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: dealType,
                    items: const [
                      DropdownMenuItem(
                        value: 'FlashDeal',
                        child: Text('โปรโมชันพิเศษ'),
                      ),
                      DropdownMenuItem(
                        value: 'LocalDeal',
                        child: Text('โปรเด็ดชุมชน'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => dealType = value ?? dealType),
                    decoration: const InputDecoration(
                      labelText: 'ประเภทโปรโมชัน',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: discountType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Percent',
                        child: Text('ลดเป็นเปอร์เซ็นต์'),
                      ),
                      DropdownMenuItem(
                        value: 'FixedAmount',
                        child: Text('ลดเป็นจำนวนเงิน'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => discountType = value ?? discountType),
                    decoration: const InputDecoration(
                      labelText: 'รูปแบบส่วนลด',
                    ),
                  ),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: discountType == 'Percent'
                          ? 'ส่วนลด (%)'
                          : 'ส่วนลด (บาท)',
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'จำนวนสิทธิ์ทั้งหมด',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'เริ่ม ${_thaiDate(startsAt)}',
                    style: GoogleFonts.krub(fontSize: 12),
                  ),
                  Text(
                    'สิ้นสุด ${_thaiDate(endsAt)}',
                    style: GoogleFonts.krub(fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: activeDeals.isNotEmpty
                          ? null
                          : () async {
                              final discount =
                                  double.tryParse(discountController.text) ?? 0;
                              final totalQuantity =
                                  int.tryParse(quantityController.text) ?? 0;
                              if (discount <= 0 ||
                                  totalQuantity <= 0 ||
                                  endsAt.isBefore(startsAt) ||
                                  (discountType == 'Percent' &&
                                      discount >= 100) ||
                                  (discountType == 'FixedAmount' &&
                                      discount >= product.price)) {
                                Get.snackbar(
                                  'ข้อมูลโปรโมชันไม่ถูกต้อง',
                                  'กรุณาตรวจสอบส่วนลด จำนวนสิทธิ์ และช่วงเวลา',
                                );
                                return;
                              }
                              final ok = await repository
                                  .createProductDeal(product.id, {
                                    'dealType': dealType,
                                    'discountType': discountType,
                                    'discountValue': discount,
                                    'totalQuantity': totalQuantity,
                                    'startsAt': startsAt.toIso8601String(),
                                    'endsAt': endsAt.toIso8601String(),
                                  });
                              if (ok) {
                                Get.back();
                                Get.snackbar(
                                  'สร้างโปรโมชันสำเร็จ',
                                  'ระบบบันทึกโปรโมชันของสินค้าแล้ว',
                                );
                              } else {
                                Get.snackbar(
                                  'สร้างโปรโมชันไม่สำเร็จ',
                                  'กรุณาตรวจสอบสต็อกและสิทธิ์ที่เหลือ',
                                );
                              }
                            },
                      child: const Text('สร้างโปรโมชัน'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    discountController.dispose();
    quantityController.dispose();
  }

  String _thaiDate(DateTime? value) {
    if (value == null) return '-';
    final thai = value.toUtc().add(const Duration(hours: 7));
    return '${thai.day}/${thai.month}/${thai.year + 543} ${thai.hour.toString().padLeft(2, '0')}:${thai.minute.toString().padLeft(2, '0')} น.';
  }
}
