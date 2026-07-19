import 'package:flutter_test/flutter_test.dart';
import 'package:projecte/main.dart';

void main() {
  testWidgets('app boot renders home view', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('New Flutter Project'), findsOneWidget);
  });
}
