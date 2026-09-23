import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../shops/models/product_model.dart';
import '../repositories/merchant_repository.dart';
import '../controllers/manage_products_controller.dart';

String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '฿$intPart';
}

class ManageProductsPage extends GetView<ManageProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F5F9,
      ), // High contrast grey page background
      appBar: AppBar(
        title: Text(
          'จัดการสินค้าในร้าน',
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
              colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'รีเฟรช',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => controller.loadProducts(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (controller.myShop.value == null) {
            Get.toNamed(AppRoutes.registerShop);
          } else {
            final result = await Get.toNamed(AppRoutes.myShopProductForm);
            if (result == true) controller.loadProducts();
          }
        },
        backgroundColor: const Color(0xFF047857),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 24),
        label: Text(
          'เพิ่มสินค้าใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดรายการสินค้า...');
        }

        final list = controller.filteredProducts;
        final totalCount = controller.products.length;
        final lowStockCount = controller.products
            .where((p) => p.quantity <= 5)
            .length;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Top Hero Banner
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient Background Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 48),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF064E3B),
                          Color(0xFF047857),
                          Color(0xFF059669),
                        ],
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Colors.amberAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.myShop.value?.shopName ??
                                    'รายการสินค้าในคลัง',
                                style: GoogleFonts.krub(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'จัดการข้อมูลราคา จำนวนสต็อก และรูปภาพสินค้าในร้าน',
                                style: GoogleFonts.krub(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Summary Cards (Overlapping)
                  Positioned(
                    bottom: -32,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildHeaderStatCard(
                            title: 'สินค้าทั้งหมด',
                            value: '$totalCount รายการ',
                            icon: Icons.inventory_2_rounded,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHeaderStatCard(
                            title: lowStockCount > 0
                                ? 'สต็อกเตือน/หมด'
                                : 'สต็อกพร้อมขาย',
                            value: lowStockCount > 0
                                ? '$lowStockCount รายการ'
                                : 'ปกติทุกรายการ',
                            icon: lowStockCount > 0
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            gradient: lowStockCount > 0
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFE11D48),
                                      Color(0xFFF43F5E),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF0284C7),
                                      Color(0xFF38BDF8),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 44)),

            // Search Bar Input Box
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาชื่อสินค้า...',
                      hintStyle: GoogleFonts.krub(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF059669),
                        size: 22,
                      ),
                      suffixIcon: controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 18,
                                color: Color(0xFF94A3B8),
                              ),
                              onPressed: () =>
                                  controller.searchQuery.value = '',
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Main Product List / Empty View
            if (list.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = list[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildProductCard(context, product),
                    );
                  }, childCount: list.length),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final isLowStock = product.quantity <= 5 && product.quantity > 0;
    final isOutOfStock = product.quantity <= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isOutOfStock
              ? const Color(0xFFFECDD3)
              : isLowStock
              ? const Color(0xFFFDE68A)
              : const Color(0xFFCBD5E1),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    ? Image.network(
                        product.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: Color(0xFF94A3B8),
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFECFDF5),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Color(0xFF059669),
                          size: 36,
                        ),
                      ),
              ),
              if (isOutOfStock)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'หมด',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Price Tag
                Text(
                  formatCurrency(product.price),
                  style: GoogleFonts.krub(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF047857),
                  ),
                ),
                const SizedBox(height: 6),

                // Badges Row (Stock & Status)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildStockBadge(product.quantity),
                    _buildStatusBadge(product.status),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action Buttons (Edit & Delete)
          Column(
            children: [
              InkWell(
                onTap: () async {
                  final result = await Get.toNamed(
                    AppRoutes.myShopProductForm,
                    arguments: product,
                  );
                  if (result == true) controller.loadProducts();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'แก้ไข',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Get.toNamed(
                  AppRoutes.myShopProductDeals,
                  arguments: product,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFB74D)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: Color(0xFFE65100),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'โปรโมชัน',
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => controller.confirmDeleteProduct(product),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Future<void> _showPromotionSheet(
    BuildContext context,
    ProductModel product,
  ) async {
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

  Widget _buildStockBadge(int quantity) {
    Color bg = const Color(0xFFECFDF5);
    Color fg = const Color(0xFF047857);
    String text = 'คงเหลือ: $quantity ชิ้น';

    if (quantity <= 0) {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFE11D48);
      text = 'หมดสต็อก';
    } else if (quantity <= 5) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      text = 'สต็อกต่ำ ($quantity)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF047857) : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'วางขายอยู่' : 'ปิดการขาย',
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isNoShop = controller.myShop.value == null;
    final isSearching = controller.searchQuery.value.isNotEmpty;

    String title = 'ยังไม่มีสินค้าในร้านของคุณ';
    String subtitle =
        'เพิ่มสินค้าเข้าสู่ร้านค้าเพื่อให้ผู้ใช้งานสามารถสั่งซื้อได้';
    IconData icon = Icons.inventory_2_outlined;
    String btnText = 'เพิ่มสินค้าแรกของคุณ';
    Color btnColor = const Color(0xFF047857);

    if (isNoShop) {
      title = 'ยังไม่ได้ลงทะเบียนร้านค้า';
      subtitle = 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าก่อนเริ่มเพิ่มรายการสินค้า';
      icon = Icons.storefront_outlined;
      btnText = 'ลงทะเบียนร้านค้าใหม่';
      btnColor = const Color(0xFFD97706);
    } else if (isSearching) {
      title = 'ไม่พบสินค้าตามคำค้นหา';
      subtitle = 'ลองค้นหาด้วยคำอื่น หรือล้างช่องค้นหาเพื่อดูสินค้าทั้งหมด';
      icon = Icons.search_off_rounded;
      btnText = 'ล้างคำค้นหา';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isNoShop
                    ? const Color(0xFFFFF7ED)
                    : const Color(0xFFECFDF5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isNoShop
                      ? const Color(0xFFFFEDD5)
                      : const Color(0xFFA7F3D0),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 54,
                color: isNoShop
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                if (isSearching) {
                  controller.searchQuery.value = '';
                } else if (isNoShop) {
                  Get.toNamed(AppRoutes.registerShop);
                } else {
                  final result = await Get.toNamed(AppRoutes.myShopProductForm);
                  if (result == true) controller.loadProducts();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              icon: Icon(
                isSearching
                    ? Icons.refresh_rounded
                    : (isNoShop ? Icons.edit_document : Icons.add_rounded),
                size: 20,
              ),
              label: Text(
                btnText,
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
