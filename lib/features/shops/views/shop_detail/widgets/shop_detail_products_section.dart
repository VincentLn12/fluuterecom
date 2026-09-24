import 'package:flutter/material.dart';
import 'package:projecte/shared/widgets/empty_widget.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/widgets/shared/product_card.dart';

class ShopDetailProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String sortOption;
  final ValueChanged<String> onSortChanged;

  const ShopDetailProductsSection({
    super.key,
    required this.products,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortOption,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row: Title + Item Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE76F51),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'สินค้าในร้านค้า',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2B22),
                  ),
                ),
              ],
            ),
            Text(
              '${products.length} รายการ',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A9D8F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Search Field + Sort Dropdown Row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0EAE6)),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF0D2B22),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'ค้นหาสินค้าในร้านนี้...',
                    hintStyle: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF8A9A95),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10, right: 6),
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: Color(0xFF2A9D8F),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0EAE6)),
              ),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sortOption,
                    alignment: Alignment.center,
                    icon: const Icon(
                      Icons.sort_rounded,
                      size: 18,
                      color: Color(0xFF2A9D8F),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'popular',
                        child: Text('ยอดนิยม', style: TextStyle(fontSize: 13)),
                      ),
                      DropdownMenuItem(
                        value: 'price_asc',
                        child: Text(
                          'ราคาต่ำ-สูง',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price_desc',
                        child: Text(
                          'ราคาสูง-ต่ำ',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) onSortChanged(val);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Product Grid
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: EmptyWidget(
              title: 'ไม่พบรายการสินค้า',
              message: 'ไม่มีสินค้าที่ตรงกับคำค้นหาหรือตัวกรองที่คุณเลือก',
              icon: Icons.inventory_2_outlined,
            ),
          )
        else
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.67,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ProductCard(item: products[index]);
            },
          ),
      ],
    );
  }
}
