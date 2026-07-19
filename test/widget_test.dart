import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projecte/main.dart';

void main() {
  testWidgets('app starts with splash page', (tester) async {
    await tester.pumpWidget(const RecipeApp());
    expect(find.text('ระบบสูตรอาหาร'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
