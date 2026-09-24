import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_review_model.dart';

class ProductDetailNavTabs extends GetView<ProductDetailController> {
  const ProductDetailNavTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF9F2),
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFFE8D9C9), width: 1.2),
        ),
      ),
      child: Obx(() {
        final currentTab = controller.activeTab.value;
        final reviewCount = controller.shopReviews.length;

        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => controller.changeTab('details'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: currentTab == 'details'
                            ? const Color(0xFFD96C2C)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'รายละเอียดสินค้า',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: currentTab == 'details'
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFF786B62),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => controller.changeTab('reviews'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: currentTab == 'reviews'
                            ? const Color(0xFFD96C2C)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'รีวิวจากผู้ซื้อ ($reviewCount)',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: currentTab == 'reviews'
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFF786B62),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProductDetailsTabContent extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsTabContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasDesc =
        product.description != null && product.description!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.5,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'รายละเอียดสินค้า',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasDesc
                ? product.description!
                : 'ไม่มีรายละเอียดเพิ่มเติมสำหรับสินค้าชิ้นนี้',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF332820),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductReviewsTabContent extends StatelessWidget {
  final List<ShopReviewModel> reviews;

  const ProductReviewsTabContent({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        color: Colors.white,
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: const Color(0xFFD96C2C).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 10),
            Text(
              'ยังไม่มีรีวิวสำหรับสินค้านี้',
              style: GoogleFonts.krub(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'สั่งซื้อสินค้านี้เพื่อเป็นคนแรกที่ร่วมแชร์ความคิดเห็น!',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: const Color(0xFF786B62),
              ),
            ),
          ],
        ),
      );
    }

    final double avgRating =
        reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: GoogleFonts.krub(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFE9C46A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${reviews.length} รีวิว',
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(5, (idx) {
                      final star = 5 - idx;
                      final count = reviews
                          .where((r) => r.rating.round() == star)
                          .length;
                      final pct = count / reviews.length;
                      return _buildRatingBar(star, pct);
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          ...reviews.map(
            (rev) => _buildReviewItem(
              userName: rev.userName,
              rating: rev.rating.round(),
              comment: rev.comment,
              createdAt:
                  '${rev.createdAt.day}/${rev.createdAt.month}/${rev.createdAt.year}',
              reply: rev.ownerReply,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text(
            '$star',
            style: GoogleFonts.krub(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star_rounded, size: 11, color: Color(0xFFE9C46A)),
          const SizedBox(width: 5),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFFE8D9C9),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFD96C2C),
                ),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String userName,
    required int rating,
    required String comment,
    required String createdAt,
    String? reply,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(
                      0xFFD96C2C,
                    ).withValues(alpha: 0.15),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                      Text(
                        createdAt,
                        style: GoogleFonts.krub(
                          fontSize: 9.5,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14,
                    color: index < rating
                        ? const Color(0xFFE9C46A)
                        : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comment,
              style: GoogleFonts.krub(
                fontSize: 12.5,
                color: const Color(0xFF332820),
                height: 1.4,
              ),
            ),
          ],
          if (reply != null && reply.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8D9C9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.reply_rounded,
                        size: 13,
                        color: Color(0xFFD96C2C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ตอบกลับจากร้านค้า:',
                        style: GoogleFonts.krub(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD96C2C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reply,
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      color: const Color(0xFF332820),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
