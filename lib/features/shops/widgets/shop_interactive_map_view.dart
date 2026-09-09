import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/routes/app_routes.dart';
import '../models/shop_model.dart';

class ShopInteractiveMapView extends StatefulWidget {
  final List<ShopModel> shops;

  const ShopInteractiveMapView({super.key, required this.shops});

  @override
  State<ShopInteractiveMapView> createState() => _ShopInteractiveMapViewState();
}

class _ShopInteractiveMapViewState extends State<ShopInteractiveMapView> {
  final MapController _mapController = MapController();

  List<ShopModel> get _validItems => widget.shops
      .where((item) =>
          item.latitude != null &&
          item.longitude != null &&
          item.latitude != 0 &&
          item.longitude != 0)
      .toList();

  LatLng get _initialCenter {
    final valid = _validItems;
    if (valid.isNotEmpty) {
      final avgLat =
          valid.map((e) => e.latitude!).reduce((a, b) => a + b) / valid.length;
      final avgLng =
          valid.map((e) => e.longitude!).reduce((a, b) => a + b) / valid.length;
      return LatLng(avgLat, avgLng);
    }
    return const LatLng(14.0234, 99.5321);
  }

  @override
  Widget build(BuildContext context) {
    final validItems = _validItems;

    if (validItems.isEmpty) {
      return Container(
        color: const Color(0xFFF7F0E6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 56,
                  color: Color(0xFFD96C2C),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ไม่พบพิกัดร้านค้าตามเงื่อนไขที่เลือก',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF332820),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'ลองเปลี่ยนการเลือกหมวดหมู่หรืออำเภออื่น',
                style: TextStyle(fontSize: 13.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: 10.5,
            minZoom: 6,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.kanchanaburi.projecte',
            ),
            MarkerLayer(
              markers: validItems.map((item) {
                return Marker(
                  point: LatLng(item.latitude!, item.longitude!),
                  width: 58,
                  height: 64,
                  alignment: Alignment.topCenter,
                  child: _buildShopImageMarkerPin(context, item),
                );
              }).toList(),
            ),
          ],
        ),

        // Count Badge
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1F17).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_rounded, size: 17, color: Color(0xFFE9C46A)),
                const SizedBox(width: 6),
                Text(
                  'พบ ${validItems.length} ร้านค้าบนแผนที่',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recenter FAB Button
        Positioned(
          bottom: 20,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'shop_map_recenter',
            onPressed: () {
              _mapController.move(_initialCenter, 10.5);
            },
            backgroundColor: const Color(0xFF2B1F17),
            foregroundColor: Colors.white,
            elevation: 6,
            child: const Icon(Icons.my_location_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildShopImageMarkerPin(BuildContext context, ShopModel item) {
    final imgUrl = item.coverImageUrl;

    return GestureDetector(
      onTap: () => _showShopPreviewSheet(context, item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Photo Frame Pin Head
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF332820), Color(0xFF1F1713)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFE9C46A), width: 2.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.38),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: imgUrl != null && imgUrl.isNotEmpty
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          _buildShopMarkerFallbackIcon(),
                    )
                  : _buildShopMarkerFallbackIcon(),
            ),
          ),

          // Downward Pointer Tail
          CustomPaint(
            size: const Size(12, 7),
            painter: _ShopPinTrianglePainter(color: const Color(0xFF332820)),
          ),
        ],
      ),
    );
  }

  Widget _buildShopMarkerFallbackIcon() {
    return Container(
      color: const Color(0xFF332820),
      child: const Center(
        child: Icon(Icons.storefront_rounded, color: Color(0xFFE9C46A), size: 24),
      ),
    );
  }

  void _showShopPreviewSheet(BuildContext context, ShopModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isOpen = item.isOpenNow;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AspectRatio(
                    aspectRatio: 21 / 9,
                    child: Image.network(
                      item.coverImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD96C2C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.categoryName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOpen ? const Color(0xFF2E7D32) : Colors.grey[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isOpen ? 'เปิดทำการ' : 'ปิดทำการ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF332820),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null && item.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final url =
                                  'https://www.google.com/maps/search/?api=1&query=${item.latitude},${item.longitude}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFD96C2C),
                              side: const BorderSide(color: Color(0xFFD96C2C)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.near_me_outlined, size: 16),
                            label: const Text('นำทาง'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.toNamed(AppRoutes.shopDetail, arguments: item);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF332820),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.storefront_rounded, size: 16),
                            label: const Text('ดูร้านค้า'),
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
    );
  }
}

class _ShopPinTrianglePainter extends CustomPainter {
  final Color color;

  _ShopPinTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ShopPinTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}

