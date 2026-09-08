import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/shop_detail_controller.dart';
import '../widgets/product_card.dart';

class ShopDetailPage extends GetView<ShopDetailController> {
  const ShopDetailPage({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6), // Warm background color matching app design system
      body: Obx(() {
        final shop = controller.shop.value;
        final isLoading = controller.isLoading.value;

        if (isLoading && shop == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F0E6),
            body: Center(
              child: LoadingWidget(message: 'กำลังโหลดข้อมูลร้านค้า...'),
            ),
          );
        }

        if (shop == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF2B1F17),
              foregroundColor: Colors.white,
              title: Text('ไม่พบข้อมูลร้านค้า', style: GoogleFonts.krub()),
            ),
            body: Center(
              child: CustomErrorWidget(
                message: 'ไม่สามารถโหลดข้อมูลร้านค้าได้',
                onRetry: () {
                  final args = Get.arguments;
                  if (args != null) {
                    controller.loadShopDetailAndProducts(
                      args is String ? args : args.id,
                    );
                  }
                },
              ),
            ),
          );
        }

        final isOpen = shop.isOpenNow;
        final coverImage = shop.coverImageUrl ?? shop.backgroundImageUrl;
        final hasLocation = shop.latitude != null &&
            shop.longitude != null &&
            shop.latitude != 0 &&
            shop.longitude != 0;

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadShopDetailAndProducts(shop.id);
          },
          color: const Color(0xFFD96C2C),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Hero AppBar Header
              SliverAppBar(
                expandedHeight: 260.0,
                pinned: true,
                backgroundColor: const Color(0xFF2B1F17),
                foregroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (coverImage != null && coverImage.isNotEmpty)
                        Image.network(
                          coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultBanner(),
                        )
                      else
                        _buildDefaultBanner(),
                      // Gradient Overlay for smooth contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Floating Status Tag
                      Positioned(
                        top: 50,
                        right: 16,
                        child: StatusBadge(
                          label: isOpen ? 'เปิดบริการอยู่' : 'ปิดให้บริการ',
                          backgroundColor: isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                          icon: isOpen ? Icons.access_time_filled : Icons.do_not_disturb_on,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Shop Details Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Metadata Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF332820).withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category & Location Badges
                            Row(
                              children: [
                                if (shop.categoryName != null && shop.categoryName!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.storefront_rounded, size: 14, color: Color(0xFFD96C2C)),
                                        const SizedBox(width: 4),
                                        Text(
                                          shop.categoryName!,
                                          style: GoogleFonts.krub(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFD96C2C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (shop.categoryName != null && shop.districtName != null)
                                  const SizedBox(width: 8),
                                if (shop.districtName != null && shop.districtName!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F5F58).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF1F5F58)),
                                        const SizedBox(width: 4),
                                        Text(
                                          shop.districtName!,
                                          style: GoogleFonts.krub(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1F5F58),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Shop Title
                            Text(
                              shop.name,
                              style: GoogleFonts.krub(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),

                            if (shop.description != null && shop.description!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                shop.description!,
                                style: GoogleFonts.krub(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ],

                            const Divider(height: 24, color: Color(0xFFEADCCF)),

                            // Info Rows (Hours, Phone, Email, Address)
                            if (shop.openingTime != null || shop.closingTime != null)
                              _buildInfoRow(
                                icon: Icons.access_time_rounded,
                                iconColor: const Color(0xFFD96C2C),
                                label: 'เวลาทำการ',
                                value: '${shop.openingTime ?? "N/A"} - ${shop.closingTime ?? "N/A"} น.',
                              ),

                            if (shop.phone != null && shop.phone!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _makePhoneCall(shop.phone!),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone_in_talk_rounded, size: 18, color: Color(0xFF1F5F58)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          shop.phone!,
                                          style: GoogleFonts.krub(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1F5F58),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1F5F58),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.call, size: 14, color: Colors.white),
                                            const SizedBox(width: 4),
                                            Text(
                                              'โทรออก',
                                              style: GoogleFonts.krub(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            if (shop.address != null && shop.address!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                icon: Icons.map_rounded,
                                iconColor: const Color(0xFFC8952F),
                                label: 'ที่อยู่ร้าน',
                                value: shop.address!,
                              ),
                            ],

                            // Open Google Maps CTA
                            if (hasLocation) ...[
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: () => _openGoogleMaps(shop.latitude!, shop.longitude!),
                                icon: const Icon(Icons.directions_outlined, size: 18),
                                label: Text(
                                  'นำทางด้วย Google Maps',
                                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1F5F58),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section Title: Products Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD96C2C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'สินค้าในร้านค้า',
                                style: GoogleFonts.krub(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2B1F17),
                                ),
                              ),
                            ],
                          ),
                          Obx(() => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEADCCF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${controller.products.length} รายการ',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2B1F17),
                                  ),
                                ),
                              )),
                        ],
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),

              // Products Grid / Empty List
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: LoadingWidget(message: 'กำลังโหลดรายการสินค้า...'),
                      ),
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                      child: EmptyWidget(
                        title: 'ยังไม่มีสินค้าในร้านนี้',
                        message: 'ร้านค้านี้ยังไม่ได้ลงรายการสินค้าในขณะนี้',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = controller.products[index];
                        return ProductCard(item: product);
                      },
                      childCount: controller.products.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: GoogleFonts.krub(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B1F17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B1F17), Color(0xFF5D4037)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.storefront_rounded, size: 72, color: Colors.white24),
      ),
    );
  }
}
