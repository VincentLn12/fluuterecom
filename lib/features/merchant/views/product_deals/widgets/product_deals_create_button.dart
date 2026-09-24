import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDealsCreateButton extends StatelessWidget {
  const ProductDealsCreateButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text(
          'สร้างโปรโมชันใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF047857),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
