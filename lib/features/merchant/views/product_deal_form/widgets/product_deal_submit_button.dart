import 'package:flutter/material.dart';

class ProductDealSubmitButton extends StatelessWidget {
  const ProductDealSubmitButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isSaving ? null : onPressed,
        icon: const Icon(Icons.save_rounded),
        label: Text(isSaving ? 'กำลังบันทึก...' : 'บันทึกโปรโมชัน'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF047857),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
