import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.shopping_cart_rounded,
              color: Color(0xFFD96C2C),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'ตะกร้าสินค้า',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final authService = Get.find<AuthService>();
              if (!authService.isLoggedIn.value) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.totalItemCount}',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          Obx(() {
            final authService = Get.find<AuthService>();
            if (!authService.isLoggedIn.value || controller.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return TextButton.icon(
              onPressed: () {
                _showConfirmClearDialog(context);
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white70,
                size: 18,
              ),
              label: Text(
                'ล้างตะกร้า',
                style: GoogleFonts.krub(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final authService = Get.find<AuthService>();
        if (!authService.isLoggedIn.value) {
          return _buildLoginRequiredView();
        }

        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyWidget(
                  title: 'ตะกร้าสินค้ายังว่างอยู่',
                  message:
                      'คุณยังไม่ได้เพิ่มสินค้าใดๆ ลงในตะกร้า\nลองเลือกดูสินค้าโอทอปและของฝากกาญจนบุรีได้เลย',
                  icon: Icons.shopping_cart_outlined,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.shops);
                  },
                  icon: const Icon(Icons.storefront_rounded, size: 20),
                  label: Text(
                    'ไปเลือกซื้อสินค้า',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD96C2C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          );
        }

        final grouped = controller.groupedByShop;

        return Column(
          children: [
            // Select All Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.isAllSelected,
                      activeColor: const Color(0xFFD96C2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        controller.toggleSelectAll(val ?? false);
                      },
                    ),
                  ),
                  Text(
                    'เลือกสินค้าทั้งหมด',
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B1F17),
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    final selectedCount = controller.cartItems
                        .where((i) => i.isSelected)
                        .length;
                    if (selectedCount == 0) return const SizedBox.shrink();
                    return TextButton(
                      onPressed: () => controller.removeSelectedItems(),
                      child: Text(
                        'ลบรายการที่เลือก ($selectedCount)',
                        style: GoogleFonts.krub(
                          color: const Color(0xFFC62828),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEADCCF)),

            // Cart Items List Grouped by Shop
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final shopId = grouped.keys.elementAt(index);
                  final items = grouped[shopId]!;
                  final shopName = items.first.effectiveShopName;
                  final isShopSelected = controller.isShopAllSelected(shopId);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFEADCCF),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF332820,
                          ).withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Header Bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          color: const Color(0xFFF7F0E6).withValues(alpha: 0.6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isShopSelected,
                                activeColor: const Color(0xFFD96C2C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (val) {
                                  controller.toggleSelectShop(
                                    shopId,
                                    val ?? false,
                                  );
                                },
                              ),
                              const Icon(
                                Icons.storefront_rounded,
                                color: Color(0xFF1F5F58),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  shopName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.krub(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2B1F17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFEADCCF)),

                        // Items under shop
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (context, i) => const Divider(
                            height: 1,
                            indent: 48,
                            endIndent: 16,
                            color: Color(0xFFF0E6DC),
                          ),
                          itemBuilder: (context, itemIndex) {
                            final item = items[itemIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Item Selection Checkbox
                                  Checkbox(
                                    value: item.isSelected,
                                    activeColor: const Color(0xFFD96C2C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      controller.toggleSelect(item.id);
                                    },
                                  ),

                                  // Product Thumbnail Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFF7F0E6),
                                      child:
                                          item.product.imageUrl != null &&
                                              item.product.imageUrl!.isNotEmpty
                                          ? Image.network(
                                              item.product.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => _buildImagePlaceholder(),
                                            )
                                          : _buildImagePlaceholder(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Product Info & Stepper
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.product.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.krub(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF2B1F17,
                                                  ),
                                                  height: 1.2,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () => controller
                                                  .removeFromCart(item.id),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Price Display
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '฿${item.product.price.toStringAsFixed(2)}',
                                                  style: GoogleFonts.krub(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFFD96C2C,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Stepper Controls (- / qty / +)
                                            Container(
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF7F0E6),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFEADCCF,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller
                                                        .decrementQuantity(
                                                          item.id,
                                                        ),
                                                    borderRadius:
                                                        const BorderRadius.horizontal(
                                                          left: Radius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      child: Icon(
                                                        item.quantity == 1
                                                            ? Icons
                                                                  .delete_outline_rounded
                                                            : Icons.remove,
                                                        size: 14,
                                                        color:
                                                            item.quantity == 1
                                                            ? const Color(
                                                                0xFFC62828,
                                                              )
                                                            : const Color(
                                                                0xFF2B1F17,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                        ),
                                                    child: Text(
                                                      '${item.quantity}',
                                                      style: GoogleFonts.krub(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF2B1F17,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () => controller
                                                        .incrementQuantity(
                                                          item.id,
                                                        ),
                                                    borderRadius:
                                                        const BorderRadius.horizontal(
                                                          right:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 14,
                                                        color: Color(
                                                          0xFF2B1F17,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Sticky Checkout Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF332820).withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Summary column
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ราคารวมทั้งหมด (${controller.selectedItemCount} ชิ้น)',
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '฿',
                                style: GoogleFonts.krub(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD96C2C),
                                ),
                              ),
                              Text(
                                controller.totalPrice.toStringAsFixed(2),
                                style: GoogleFonts.krub(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFD96C2C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Checkout CTA Button
                    ElevatedButton(
                      onPressed: () {
                        if (controller.selectedItemCount == 0) {
                          Get.snackbar(
                            'ยังไม่ได้เลือกสินค้า',
                            'กรุณาเลือกสินค้าอย่างน้อย 1 รายการในตะกร้าเพื่อทำรายการสั่งซื้อ',
                            backgroundColor: const Color(0xFFC62828),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }
                        Get.toNamed(AppRoutes.checkout);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C2C),
                        disabledBackgroundColor: Colors.grey[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'สั่งซื้อสินค้า',
                            style: GoogleFonts.krub(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoginRequiredView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2B1F17).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 52,
                color: Color(0xFFD96C2C),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'กรุณาเข้าสู่ระบบก่อนใช้งานตะกร้าสินค้า',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B1F17),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'เพื่อดูและจัดการรายการสินค้าในตะกร้าส่วนตัวของคุณ\nกรุณาเข้าสู่ระบบหรือสมัครสมาชิกก่อนเริ่มสั่งซื้อ',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.login);
              },
              icon: const Icon(Icons.login_rounded, size: 20),
              label: Text(
                'เข้าสู่ระบบ / สมัครสมาชิก',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF2B1F17),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white54,
          size: 24,
        ),
      ),
    );
  }

  void _showConfirmClearDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'ยืนยันการล้างตะกร้าสินค้า',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'คุณต้องการลบสินค้าทั้งหมดออกจากตะกร้าใช่หรือไม่?',
          style: GoogleFonts.krub(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ล้างตะกร้า',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
