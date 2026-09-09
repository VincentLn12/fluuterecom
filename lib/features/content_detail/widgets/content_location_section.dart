import 'package:flutter/material.dart';
import '../models/content_detail_model.dart';
import '../../contents/widgets/content_map_widget.dart';

class ContentLocationSection extends StatelessWidget {
  final ContentDetailModel item;
  final VoidCallback onOpenMap;

  const ContentLocationSection({
    super.key,
    required this.item,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final lat = item.latitude ?? 14.0227;
    final lng = item.longitude ?? 99.5328;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEADCCF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map_rounded,
                  color: Color(0xFFD96C2C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'ตำแหน่งพิกัดและเส้นทาง',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B1F17),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Boarding Pass Location Ticket Card (No fixed height constraint)
          ContentMapWidget(
            latitude: lat,
            longitude: lng,
            title: item.title,
            shopName: item.shopName,
            districtName: item.districtName,
          ),
        ],
      ),
    );
  }
}
