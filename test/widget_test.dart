import 'package:flutter_test/flutter_test.dart';
import 'package:projecte/main.dart';

void main() {
  testWidgets('app boot renders login view', (tester) async {
    await tester.pumpWidget(const DormitoryApp());
    expect(find.text('เข้าสู่ระบบ'), findsNWidgets(2));
    expect(find.text('สำหรับผู้เช่าและเจ้าของหอพัก'), findsOneWidget);
  });
}
