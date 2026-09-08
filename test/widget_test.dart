import 'package:flutter_test/flutter_test.dart';
import 'package:projecte/main.dart';

void main() {
  testWidgets('app renders navbar', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('หน้าแรก'), findsWidgets);
  });
}
