import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_details_card.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_product_summary.dart';

class ProductDealFormPage extends StatefulWidget {
  const ProductDealFormPage({super.key});
  @override
  State<ProductDealFormPage> createState() => _ProductDealFormPageState();
}

class _ProductDealFormPageState extends State<ProductDealFormPage> {
  final repository = MerchantRepository();
  final discount = TextEditingController();
  final quantity = TextEditingController();
  final starts = TextEditingController();
  final ends = TextEditingController();
  ProductModel? product;
  DateTime? startDate;
  DateTime? endDate;
  String dealType = 'FlashDeal';
  String discountType = 'Percent';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      quantity.text = args.quantity.toString();
      final now = DateTime.now().toUtc();
      startDate = now;
      endDate = now.add(const Duration(days: 1));
      starts.text = _displayDate(startDate!);
      ends.text = _displayDate(endDate!);
    }
  }

  Future<void> save() async {
    final item = product;
    if (item == null) return;
    final value = double.tryParse(discount.text) ?? 0;
    final total = int.tryParse(quantity.text) ?? 0;
    final start = startDate?.toUtc();
    final end = endDate?.toUtc();
    if (value <= 0 ||
        total <= 0 ||
        start == null ||
        end == null ||
        !end.isAfter(start) ||
        (discountType == 'Percent' && value >= 100) ||
        (discountType == 'FixedAmount' && value >= item.price)) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'กรุณาตรวจสอบส่วนลด จำนวนสิทธิ์ และช่วงเวลา',
      );
      return;
    }
    setState(() => saving = true);
    final ok = await repository.createProductDeal(item.id, {
      'dealType': dealType,
      'discountType': discountType,
      'discountValue': value,
      'totalQuantity': total,
      'startsAt': start.toIso8601String(),
      'endsAt': end.toIso8601String(),
    });
    if (!mounted) return;
    setState(() => saving = false);
    if (ok) {
      Get.back(result: true);
      Get.snackbar(
        'สร้างโปรโมชันสำเร็จ',
        'เพิ่มโปรโมชันให้สินค้าเรียบร้อยแล้ว',
        backgroundColor: const Color(0xFF047857),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'สร้างโปรโมชันไม่สำเร็จ',
        'กรุณาตรวจสอบสต็อกและสิทธิ์ที่เหลือ',
      );
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = (isStart ? startDate : endDate) ?? DateTime.now().toUtc();
    final localCurrent = current.toLocal();
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: localCurrent,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 2, today.month, today.day),
      helpText: isStart
          ? 'เลือกวันที่เริ่มโปรโมชัน'
          : 'เลือกวันที่สิ้นสุดโปรโมชัน',
      cancelText: 'ยกเลิก',
      confirmText: 'เลือกวันที่',
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(localCurrent),
      helpText: isStart ? 'เลือกเวลาเริ่มโปรโมชัน' : 'เลือกเวลาสิ้นสุดโปรโมชัน',
      cancelText: 'ยกเลิก',
      confirmText: 'ยืนยันเวลา',
    );
    if (time == null || !mounted) return;
    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).toUtc();
    setState(() {
      if (isStart) {
        startDate = selected;
        starts.text = _displayDate(selected);
      } else {
        endDate = selected;
        ends.text = _displayDate(selected);
      }
    });
  }

  String _displayDate(DateTime value) {
    final thai = value.toUtc().add(const Duration(hours: 7));
    final day = thai.day.toString().padLeft(2, '0');
    final month = thai.month.toString().padLeft(2, '0');
    final hour = thai.hour.toString().padLeft(2, '0');
    final minute = thai.minute.toString().padLeft(2, '0');
    return '$day/$month/${thai.year + 543} เวลา $hour:$minute น.';
  }

  @override
  void dispose() {
    discount.dispose();
    quantity.dispose();
    starts.dispose();
    ends.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = product;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'สร้างโปรโมชัน',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
      ),
      body: item == null
          ? const Center(child: Text('ไม่พบข้อมูลสินค้า'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductDealProductSummary(product: item),
                const SizedBox(height: 18),
                ProductDealDetailsCard(
                  dealType: dealType,
                  onDealTypeChanged: (value) =>
                      setState(() => dealType = value),
                  discountType: discountType,
                  onDiscountTypeChanged: (value) =>
                      setState(() => discountType = value),
                  discountController: discount,
                  quantityController: quantity,
                  startsController: starts,
                  endsController: ends,
                  onStartTap: () => _pickDateTime(isStart: true),
                  onEndTap: () => _pickDateTime(isStart: false),
                  isSaving: saving,
                  onSave: save,
                ),
              ],
            ),
    );
  }
}
