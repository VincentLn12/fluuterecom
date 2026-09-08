import 'package:flutter/material.dart';

class AppCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color backgroundColor;

  const AppCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = const Color(0xFFD96C2C),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: selectedColor,
      backgroundColor: backgroundColor,
      side: const BorderSide(color: Color(0xFFE8D9C9)),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF332820),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
