import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_product_summary.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_list_card.dart';
import 'package:projecte/features/merchant/views/product_deals/widgets/product_deals_create_button.dart';
import 'package:projecte/features/merchant/repositories/merchant_repository.dart';

class ProductDealsPage extends StatefulWidget {
  const ProductDealsPage({super.key});

  @override
  State<ProductDealsPage> createState() => _ProductDealsPageState();
}

class _ProductDealsPageState extends State<ProductDealsPage> {
  final _repository = MerchantRepository();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _startsController = TextEditingController();
  final _endsController = TextEditingController();
  ProductModel? product;
  List<dynamic> deals = [];
  bool loading = true;
  bool saving = false;
  String dealType = 'FlashDeal';
  String discountType = 'Percent';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      _quantityController.text = args.quantity.toString();
      final now = DateTime.now().toUtc();
      _startsController.text = now.toIso8601String();
      _endsController.text = now.add(const Duration(days: 1)).toIso8601String();
      _loadDeals();
    } else {
      loading = false;
    }
  }

  Future<void> _loadDeals() async {
    final item = product;
    if (item == null) return;
    setState(() => loading = true);
    final result = await _repository.fetchProductDeals(item.id);
    if (mounted) {
      setState(() {
        deals = result;
        loading = false;
      });
    }
  }

  Future<void> _createDeal() async {
    final item = product;
    if (item == null) return;
    final discount = double.tryParse(_discountController.text) ?? 0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final starts = DateTime.tryParse(_startsController.text)?.toUtc();
    final ends = DateTime.tryParse(_endsController.text)?.toUtc();
    if (discount <= 0 ||
        quantity <= 0 ||
        starts == null ||
        ends == null ||
        !ends.isAfter(starts) ||
        (discountType == 'Percent' && discount >= 100) ||
        (discountType == 'FixedAmount' && discount >= item.price)) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'ตรวจสอบส่วนลด จำนวนสิทธิ์ และช่วงเวลาอีกครั้ง',
      );
      return;
    }
    setState(() => saving = true);
    final ok = await _repository.createProductDeal(item.id, {
      'dealType': dealType,
      'discountType': discountType,
      'discountValue': discount,
      'totalQuantity': quantity,
      'startsAt': starts.toIso8601String(),
      'endsAt': ends.toIso8601String(),
    });
    if (mounted) setState(() => saving = false);
    if (ok) {
      _discountController.clear();
      await _loadDeals();
      Get.snackbar(
        'สร้างโปรโมชันสำเร็จ',
        'เพิ่มดีลให้สินค้านี้แล้ว',
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

  Future<void> _stopDeal(String id) async {
    final ok = await _repository.stopProductDeal(id);
    if (ok) await _loadDeals();
  }

  @override
  void dispose() {
    _discountController.dispose();
    _quantityController.dispose();
    _startsController.dispose();
    _endsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = product;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'จัดการโปรโมชัน',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Get.toNamed(
                AppRoutes.myShopProductDealForm,
                arguments: item,
              );
              if (result == true) _loadDeals();
            },
            icon: const Icon(Icons.add_rounded),
            tooltip: 'สร้างโปรโมชัน',
          ),
          IconButton(
            onPressed: _loadDeals,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: item == null
          ? const Center(child: Text('ไม่พบข้อมูลสินค้า'))
          : loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductDealsProductSummary(product: item),
                const SizedBox(height: 18),
                ProductDealsListCard(deals: deals, onStopDeal: _stopDeal),
                const SizedBox(height: 16),
                ProductDealsCreateButton(
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.myShopProductDealForm,
                      arguments: item,
                    );
                    if (result == true) _loadDeals();
                  },
                ),
              ],
            ),
    );
  }

  // ignore: unused_element
  Widget _buildCreateCard() => _card(
    'สร้างโปรโมชันใหม่',
    Icons.add_circle_outline_rounded,
    [
      DropdownButtonFormField<String>(
        initialValue: dealType,
        items: const [
          DropdownMenuItem(value: 'FlashDeal', child: Text('โปรโมชันพิเศษ')),
          DropdownMenuItem(value: 'LocalDeal', child: Text('โปรเด็ดชุมชน')),
        ],
        onChanged: (value) => setState(() => dealType = value ?? dealType),
        decoration: const InputDecoration(labelText: 'ประเภทโปรโมชัน'),
      ),
      DropdownButtonFormField<String>(
        initialValue: discountType,
        items: const [
          DropdownMenuItem(value: 'Percent', child: Text('ลดเป็นเปอร์เซ็นต์')),
          DropdownMenuItem(
            value: 'FixedAmount',
            child: Text('ลดเป็นจำนวนเงิน'),
          ),
        ],
        onChanged: (value) =>
            setState(() => discountType = value ?? discountType),
        decoration: const InputDecoration(labelText: 'รูปแบบส่วนลด'),
      ),
      TextField(
        controller: _discountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: discountType == 'Percent' ? 'ส่วนลด (%)' : 'ส่วนลด (บาท)',
        ),
      ),
      TextField(
        controller: _quantityController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'จำนวนสิทธิ์ทั้งหมด'),
      ),
      TextField(
        controller: _startsController,
        decoration: const InputDecoration(labelText: 'เวลาเริ่ม (ISO/UTC)'),
      ),
      TextField(
        controller: _endsController,
        decoration: const InputDecoration(labelText: 'เวลาสิ้นสุด (ISO/UTC)'),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: saving ? null : _createDeal,
          icon: const Icon(Icons.save_rounded),
          label: Text(saving ? 'กำลังบันทึก...' : 'สร้างโปรโมชัน'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF047857),
            foregroundColor: Colors.white,
          ),
        ),
      ),
    ],
  );

  Widget _card(String title, IconData icon, List<Widget> children) => Container(
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
            Icon(icon, color: const Color(0xFFE65100)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        ...children,
      ],
    ),
  );
}
