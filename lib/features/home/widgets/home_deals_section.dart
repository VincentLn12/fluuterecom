import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/product_model.dart';
import '../../shops/widgets/product_card.dart';
import '../controllers/home_controller.dart';

class HomeDealsSection extends GetView<HomeController> {
  const HomeDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final deals = controller.activeDeals.where((product) {
        final deal = product.activeDeal;
        return product.quantity > 0 &&
            deal != null &&
            deal.availableQuantity > 0 &&
            !deal.isExpired;
      }).toList();
      if (deals.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFE65100),
                ),
                const SizedBox(width: 7),
                Text(
                  'โปรโมชันพิเศษ',
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 286,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              itemCount: deals.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, index) =>
                  SizedBox(width: 190, child: ProductCard(item: deals[index])),
            ),
          ),
        ],
      );
    });
  }
}

// ignore: unused_element
class _DealCard extends StatelessWidget {
  final ProductModel product;
  const _DealCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal!;
    return SizedBox(
      width: 190,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFCCBC)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 132,
                    width: double.infinity,
                    child: product.imageUrl?.isNotEmpty == true
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        deal.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      product.shopName ?? 'ร้านค้าชุมชน',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '฿${product.dealPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.krub(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE65100),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '฿${product.price.toStringAsFixed(0)}',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StreamBuilder<int>(
                      stream: Stream.periodic(
                        const Duration(seconds: 1),
                        (tick) => tick,
                      ),
                      builder: (_, _) {
                        final left = deal.endsAt == null
                            ? Duration.zero
                            : deal.endsAt!.difference(DateTime.now().toUtc());
                        final d = left.isNegative ? Duration.zero : left;
                        final time =
                            '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
                        return Text(
                          'เหลือเวลา $time • เหลือ ${deal.availableQuantity} สิทธิ์',
                          style: GoogleFonts.krub(
                            fontSize: 10.5,
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFFFEDE7),
    child: const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Color(0xFFE65100),
        size: 38,
      ),
    ),
  );
}
