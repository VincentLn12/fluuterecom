import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentMapWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? title;
  final String? shopName;
  final String? districtName;

  const ContentMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.title,
    this.shopName,
    this.districtName,
  });

  bool get hasValidCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude != 0 &&
      longitude != 0;

  Future<void> _openGoogleMaps() async {
    if (!hasValidCoordinates) return;
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasValidCoordinates) {
      return const SizedBox.shrink();
    }

    final locationText = [
      if (shopName != null && shopName!.isNotEmpty) shopName,
      if (districtName != null && districtName!.isNotEmpty) 'อ.$districtName',
      'จ.กาญจนบุรี',
    ].join(' ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF332820),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map Background Decoration Pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.map_outlined,
              size: 140,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ตำแหน่งสถานที่ / หมุดแผนที่',
                            style: TextStyle(
                              color: Color(0xFFE8D9C9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            locationText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.explore_outlined,
                          size: 16, color: Color(0xFFE9C46A)),
                      const SizedBox(width: 6),
                      Text(
                        'พิกัด: ${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openGoogleMaps,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD96C2C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.near_me_rounded, size: 18),
                    label: const Text(
                      'เปิดนำทางด้วย Google Maps',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
