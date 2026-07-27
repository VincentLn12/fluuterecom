import 'package:flutter/material.dart';
import '../../../models/ingredient.dart';

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD8BF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFE85D24), size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF24160F),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF8C7465),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAD7C7)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8C7465),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class IngredientList extends StatelessWidget {
  const IngredientList({
    super.key,
    required this.ingredients,
    required this.multiplier,
  });

  final List<Ingredient> ingredients;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFDEC8)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < ingredients.length; index++) ...[
            IngredientTile(
              ingredient: ingredients[index],
              multiplier: multiplier,
            ),
            if (index != ingredients.length - 1)
              const Divider(height: 1, color: Color(0xFFF0E3D8)),
          ],
        ],
      ),
    );
  }
}

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
    final amountText = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(1);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: const Icon(Icons.check_circle_rounded, color: Color(0xFFE85D24)),
      title: Text(
        ingredient.name,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3EA),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$amountText ${ingredient.unit}',
          style: const TextStyle(
            color: Color(0xFFE85D24),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
