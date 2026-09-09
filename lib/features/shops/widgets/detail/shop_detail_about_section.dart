import 'package:flutter/material.dart';
import '../../models/shop_model.dart';

class ShopDetailAboutSection extends StatelessWidget {
  final ShopModel shop;
  final Function(String) onCallPhone;

  const ShopDetailAboutSection({
    super.key,
    required this.shop,
    required this.onCallPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 4.5,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A9D8F),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'เกี่ยวกับร้านค้า',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D2B22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Description Text
          if (shop.description != null && shop.description!.isNotEmpty) ...[
            Text(
              shop.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF334E45),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE0EAE6)),
            const SizedBox(height: 14),
          ],

          // Category & District Badges
          if ((shop.categoryName != null && shop.categoryName!.isNotEmpty) ||
              (shop.districtName != null && shop.districtName!.isNotEmpty) ||
              (shop.subDistrictName != null && shop.subDistrictName!.isNotEmpty)) ...[
            const Text(
              'ข้อมูลหมวดหมู่ & ที่ตั้ง',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B22),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (shop.categoryName != null && shop.categoryName!.isNotEmpty)
                  _buildHighlightChip('🏪 หมวดหมู่: ${shop.categoryName!}'),
                if (shop.districtName != null && shop.districtName!.isNotEmpty)
                  _buildHighlightChip('📍 อำเภอ: ${shop.districtName!}'),
                if (shop.subDistrictName != null && shop.subDistrictName!.isNotEmpty)
                  _buildHighlightChip('🏞️ ตำบล: ${shop.subDistrictName!}'),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFE0EAE6)),
            const SizedBox(height: 14),
          ],

          // Store Contact Info List
          const Text(
            'ข้อมูลการติดต่อ & เวลาทำการ',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D2B22),
            ),
          ),
          const SizedBox(height: 12),

          // 1. Hours
          if (shop.openingTime != null || shop.closingTime != null)
            _buildInfoRow(
              icon: Icons.access_time_filled_rounded,
              iconColor: const Color(0xFF2A9D8F),
              label: 'เวลาเปิดให้บริการ',
              value: '${shop.openingTime ?? "08:00"} - ${shop.closingTime ?? "18:00"} น.',
            ),

          // 2. Phone Call
          if (shop.phone != null && shop.phone!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.phone_in_talk_rounded,
                  size: 19,
                  color: Color(0xFF2A9D8F),
                ),
                const SizedBox(width: 10),
                const Text(
                  'เบอร์โทรศัพท์: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A7B70),
                  ),
                ),
                Expanded(
                  child: Text(
                    shop.phone!,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D2B22),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => onCallPhone(shop.phone!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A9D8F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.call, size: 14),
                  label: const Text('โทรออก', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],

          // 3. Email
          if (shop.email != null && shop.email!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.email_rounded,
              iconColor: const Color(0xFFE76F51),
              label: 'อีเมล',
              value: shop.email!,
            ),
          ],

          // 4. Address
          if (shop.address != null && shop.address!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.location_on_rounded,
              iconColor: const Color(0xFFE9C46A),
              label: 'ที่อยู่ร้านค้า',
              value: shop.address!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A9D8F).withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F382C),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: iconColor),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A7B70),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D2B22),
            ),
          ),
        ),
      ],
    );
  }
}
