import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shops/models/product_model.dart';
import '../repositories/merchant_repository.dart';

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
                Text(
                  item.name,
                  style: GoogleFonts.krub(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ราคาปกติ ฿${item.price.toStringAsFixed(2)} • สต็อก ${item.quantity} ชิ้น',
                  style: GoogleFonts.krub(color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายละเอียดโปรโมชัน',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                        onChanged: (v) =>
                            setState(() => dealType = v ?? dealType),
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
                        onChanged: (v) =>
                            setState(() => discountType = v ?? discountType),
                        decoration: const InputDecoration(
                          labelText: 'รูปแบบส่วนลด',
                        ),
                      ),
                      TextField(
                        controller: discount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: discountType == 'Percent'
                              ? 'ส่วนลด (%)'
                              : 'ส่วนลด (บาท)',
                        ),
                      ),
                      TextField(
                        controller: quantity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'จำนวนสิทธิ์ทั้งหมด',
                        ),
                      ),
                      TextField(
                        controller: starts,
                        readOnly: true,
                        onTap: () => _pickDateTime(isStart: true),
                        decoration: const InputDecoration(
                          labelText: 'วันและเวลาเริ่มต้น',
                          hintText: 'แตะเพื่อเลือกวันและเวลา',
                          suffixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                      ),
                      TextField(
                        controller: ends,
                        readOnly: true,
                        onTap: () => _pickDateTime(isStart: false),
                        decoration: const InputDecoration(
                          labelText: 'วันและเวลาสิ้นสุด',
                          hintText: 'แตะเพื่อเลือกวันและเวลา',
                          suffixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: saving ? null : save,
                          icon: const Icon(Icons.save_rounded),
                          label: Text(
                            saving ? 'กำลังบันทึก...' : 'บันทึกโปรโมชัน',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF047857),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
