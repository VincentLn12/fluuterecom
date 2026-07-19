import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/ingredient.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.multiplier,
  });

  final Ingredient ingredient;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    final amount = ingredient.amount * multiplier;
    final amountText = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(1);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CircleAvatar(
        radius: 16.r,
        child: const Icon(Icons.restaurant, size: 18),
      ),
      title: Text(ingredient.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text('$amountText ${ingredient.unit}'),
    );
  }
}
