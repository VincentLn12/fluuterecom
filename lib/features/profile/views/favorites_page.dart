import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/favorites_controller.dart';
import '../models/favorite_content_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'รายการโปรดที่บันทึกไว้',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.fetchFavorites(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE76F51),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFE76F51),
          onRefresh: () => controller.fetchFavorites(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Header Banner
                _buildHeroHeader(context),

                const SizedBox(height: 18),

                // 2. Favorites List or Empty State
                controller.favoritesList.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.favoritesList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = controller.favoritesList[index];
                          return _buildFavoriteCard(context, controller, item);
                        },
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE76F51).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFE76F51),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายการโปรดที่บันทึกไว้',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFF332820),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'รวมเรื่องราว สถานที่ท่องเที่ยว และบทความที่คุณชื่นชอบและกดบันทึกเก็บไว้',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF786B62),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    FavoritesController controller,
    FavoriteContentModel item,
  ) {
    final imageUrl = item.coverImageUrl?.isNotEmpty == true
        ? item.coverImageUrl!
        : (item.youtubeThumbnail.isNotEmpty ? item.youtubeThumbnail : null);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Thumbnail Image & Favorite Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  color: const Color(0xFFE8D9C9).withValues(alpha: 0.5),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageFallback(),
                        )
                      : _buildImageFallback(),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE76F51),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x25000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        'รายการโปรด',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Card Content Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF332820),
                    height: 1.3,
                  ),
                ),
                if (item.summary != null && item.summary!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.summary!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF786B62),
                      height: 1.35,
                    ),
                  ),
                ],
                if (item.createdAt != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: Color(0xFF786B62)),
                      const SizedBox(width: 4),
                      Text(
                        'บันทึกเมื่อ: ${_formatDate(item.createdAt!)}',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE8D9C9)),
                const SizedBox(height: 10),

                // 3. Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.contentDetail
                              .replaceAll(':id', item.contentId),
                        );
                      },
                      icon: const Icon(Icons.menu_book_rounded, size: 16),
                      label: Text(
                        'อ่านบทความ',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C2C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite,
                          size: 22, color: Color(0xFFE76F51)),
                      tooltip: 'นำออกจากรายการโปรด',
                      onPressed: () => controller.removeFavorite(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: const Color(0xFFE8D9C9).withValues(alpha: 0.4),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFF786B62),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE76F51).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: Color(0xFFE76F51),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีรายการโปรด',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'คุณสามารถกดบันทึกบทความหรือสถานที่ท่องเที่ยวที่ถูกใจ เพื่อกลับมาอ่านในภายหลังได้',
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontSize: 13,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.contents),
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: Text(
              'สำรวจคอนเทนต์ท่องเที่ยว',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      const months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      final monthName = months[dt.month - 1];
      final yearThai = dt.year + 543;
      return '${dt.day} $monthName $yearThai';
    } catch (_) {
      return isoDate;
    }
  }
}
