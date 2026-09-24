import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/models/product_model.dart';

class ProductDealsProductSummary extends StatelessWidget {
  const ProductDealsProductSummary({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: GoogleFonts.krub(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'ราคาปกติ ฿${product.price.toStringAsFixed(2)} • สต็อก ${product.quantity} ชิ้น',
          style: GoogleFonts.krub(color: const Color(0xFF64748B)),
        ),
      ],
    );
  }
}
