import 'package:flutter/material.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../models/shop_review_model.dart';

class ShopDetailReviewsSection extends StatelessWidget {
  final List<ShopReviewModel> reviews;
  final double averageRating;

  const ShopDetailReviewsSection({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    int countStar(int star) =>
        reviews.where((r) => r.rating.round() == star).length;
    double ratioStar(int star) =>
        reviews.isEmpty ? 0.0 : countStar(star) / reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              width: 4.5,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFE9C46A),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'รีวิวจากผู้ซื้อจริง',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B22),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Rating Overview Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Score Box
              Column(
                children: [
                  Text(
                    reviews.isNotEmpty ? averageRating.toStringAsFixed(1) : '0.0',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D2B22),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_rounded,
                        color: index < averageRating.floor()
                            ? const Color(0xFFE9C46A)
                            : Colors.grey[300],
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reviews.length} ความคิดเห็น',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5A7B70),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 75, color: const Color(0xFFE0EAE6)),
              const SizedBox(width: 20),

              // Star Breakdown Progress Bars
              Expanded(
                child: Column(
                  children: [
                    _buildStarBar(5, ratioStar(5)),
                    _buildStarBar(4, ratioStar(4)),
                    _buildStarBar(3, ratioStar(3)),
                    _buildStarBar(2, ratioStar(2)),
                    _buildStarBar(1, ratioStar(1)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Review List Cards or Empty State
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: EmptyWidget(
              title: 'ยังไม่มีรีวิวสำหรับร้านนี้',
              message: 'ร้านค้านี้ยังไม่มีความคิดเห็นหรือรีวิวจากผู้ซื้อในขณะนี้',
              icon: Icons.star_outline_rounded,
            ),
          )
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE0EAE6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Avatar & Name
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(
                            0xFF2A9D8F,
                          ).withValues(alpha: 0.15),
                          child: Text(
                            review.userName.isNotEmpty ? review.userName[0] : 'U',
                            style: const TextStyle(
                              color: Color(0xFF2A9D8F),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0D2B22),
                                    ),
                                  ),
                                  if (review.isVerifiedBuyer) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF2A9D8F,
                                        ).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 11,
                                            color: Color(0xFF2A9D8F),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'ผู้ซื้อจริง',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2A9D8F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: i < review.rating.floor()
                                          ? const Color(0xFFE9C46A)
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Review Comment
                    Text(
                      review.comment,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF334E45),
                        height: 1.4,
                      ),
                    ),

                    // Shop Owner Reply Box (if any)
                    if (review.ownerReply != null &&
                        review.ownerReply!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F7F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2A9D8F).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.reply_rounded,
                                  size: 15,
                                  color: Color(0xFF2A9D8F),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'คำตอบจากร้านค้า',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A9D8F),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              review.ownerReply!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0D2B22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStarBar(int starNum, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text(
            '$starNum',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFE9C46A)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0EAE6),
                color: const Color(0xFFE9C46A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
