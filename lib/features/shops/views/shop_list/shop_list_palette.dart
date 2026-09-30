import 'package:flutter/material.dart';

/// Design tokens and color system for the Shop List feature,
/// harmonized with Kanchanaburi Emerald River & Amber Coral theme.
abstract final class ShopListPalette {
  // Canvas & Backgrounds
  static const canvas = Color(0xFFF4F7F5);
  static const surface = Colors.white;
  static const surfaceMuted = Color(0xFFEDF3F0);

  // Typography & Inks
  static const ink = Color(0xFF0D2B22); // Deep Teal Black
  static const inkSecondary = Color(0xFF26493E);
  static const muted = Color(0xFF5A7B70); // Muted Forest Sage
  static const mutedLight = Color(0xFF8BA69D);

  // Brand Accents
  static const primary = Color(0xFF1B4D3E); // Emerald River Teal
  static const primaryDark = Color(0xFF0F382C); // Deep Forest Teal
  static const primaryLight = Color(0xFF2A9D8F); // Vibrant Mint Teal
  static const primarySoft = Color(0xFFE6F3EE);

  // Coral & Amber (Deals & Highlights)
  static const orange = Color(0xFFE76F51); // Amber Coral Orange
  static const orangeDark = Color(0xFFBF4F35);
  static const orangeSoft = Color(0xFFFDEEE9);
  static const gold = Color(0xFFE9C46A);
  static const goldSoft = Color(0xFFFFF7E6);

  // Status & Dividers
  static const line = Color(0xFFE0EAE6);
  static const lineLight = Color(0xFFEDF3F0);
  static const green = Color(0xFF1B9966);
  static const greenSoft = Color(0xFFE5F7EE);
  static const red = Color(0xFFE63946);

  // Shadows
  static const cardShadow = [
    BoxShadow(
      color: Color(0x0C0D2B22),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x050D2B22),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const heroShadow = [
    BoxShadow(
      color: Color(0x180F382C),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];
}
