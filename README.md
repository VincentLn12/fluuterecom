# ระบบสูตรอาหาร

โปรเจค Flutter สำหรับฝึก Syntax ตั้งแต่พื้นฐานจนถึง GetX โดยออกแบบให้โค้ดอ่านง่าย แยกไฟล์ชัดเจน และเชื่อมต่อข้อมูลผ่าน `json-server` จากไฟล์ `db.json`

## Feature

- Splash Screen พร้อม `initState()` และเปลี่ยนหน้าเข้า Home อัตโนมัติ
- หน้าหลัก 5 เมนูด้วย `BottomNavigationBar` และ `IndexedStack`
- หน้า `สูตรของฉัน` แสดงรายการสูตรที่ผู้ใช้จัดการได้ พร้อมปุ่มเพิ่มสูตรอาหาร
- โหลดสูตรอาหารและหมวดหมู่จาก REST API
- ค้นหาและกรองสูตรอาหารตามชื่อ หมวดหมู่ วัตถุดิบ ระดับความยาก และรายการโปรด
- เพิ่ม แก้ไข ลบ สูตรอาหารผ่าน Form พร้อม validation
- ระบบ User/Admin สำหรับฝึก role-based CRUD
- คำนวณปริมาณวัตถุดิบใหม่ตามจำนวนเสิร์ฟ
- Favorite, Empty State, Error State, Loading State
- Light/Dark Mode ด้วย GetX
- Responsive UI ด้วย `flutter_screenutil`
- มีตัวอย่าง `Navigator.push()` สำหรับเปิดหน้ารายละเอียดเมนู และ `Navigator.pop()` สำหรับกลับหน้าก่อนหน้า

## การใช้งาน Navigator.push / Navigator.pop

โปรเจคนี้ใช้ GetX สำหรับ route หลัก แต่มีตัวอย่าง `Navigator` ตาม requirement ดังนี้:

- `Navigator.push()` อยู่ใน `lib/routes/app_navigator.dart` เมธอด `openRecipeDetail()` ใช้เปิดหน้า `RecipeDetailPage`
- `Navigator.pop()` อยู่ใน `lib/pages/recipe_detail/recipe_detail_page.dart` ใช้กับปุ่มย้อนกลับของหน้ารายละเอียด
- `Navigator.pop()` อยู่ใน `lib/pages/recipe_form/recipe_form_page.dart` ใช้กับปุ่ม `ยกเลิก` ในฟอร์มเพิ่ม/แก้ไขสูตร

ตัวอย่าง:

```dart
Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (_) => RecipeDetailPage(recipe: recipe),
  ),
);
```

```dart
Navigator.pop(context);
```

## โครงสร้างโปรเจค

```text
lib/
├── main.dart
├── bindings/
├── controllers/
├── models/
├── pages/
├── services/
├── themes/
├── utils/
└── widgets/
```

## Package ที่ใช้

- `get`
- `flutter_screenutil`
- `http`
- `cupertino_icons`
- `flutter_lints`

## วิธีติดตั้ง Flutter Package

```bash
flutter pub get
```

## วิธีเปิด json-server

```bash
npm install -g json-server
json-server --watch db.json --port 3000
```

## วิธีรันบน Android Emulator

```bash
flutter run
```

Android Emulator ใช้ base URL เป็น `http://10.0.2.2:3000`
iOS Simulator ใช้ base URL เป็น `http://localhost:3000`

## วิธีเปลี่ยน Base URL

แก้ค่า `androidBaseUrl` หรือ `localBaseUrl` ใน `lib/utils/constants.dart`

```dart
static const String androidBaseUrl = 'http://10.0.2.2:3000';
static const String localBaseUrl = 'http://localhost:3000';
```

ถ้ารันบน iOS Simulator มักใช้ `http://localhost:3000`

## ระบบ User และ Admin

โปรเจคนี้มีหน้า Login/Register และบัญชีตัวอย่างใน `db.json` สำหรับฝึกสิทธิ์การใช้งาน:

- `student@example.com` / `123456` เป็น `User` จัดการได้เฉพาะสูตรที่มี `ownerId` เป็น `user-1`
- `cook@example.com` / `123456` เป็น `User` จัดการได้เฉพาะสูตรที่มี `ownerId` เป็น `user-2`
- `admin@example.com` / `admin123` เป็น `Admin` จัดการสูตรได้ทั้งหมด

หน้า Login มีปุ่ม `เข้าแบบไว` สำหรับเข้าเป็นสมาชิกหรือแอดมินโดยไม่ต้องพิมพ์บัญชีเอง และยังสลับบัญชีได้ที่หน้า `โปรไฟล์` เพื่อทดลอง role ได้เร็วขึ้น

แท็บ `สูตรของฉัน` จะแสดงรายการสูตรที่ผู้ใช้ปัจจุบันจัดการได้ โดยสมาชิกทั่วไปเห็นเฉพาะสูตรของตัวเอง ส่วนแอดมินเห็นทั้งหมด สูตรที่ไม่มีสิทธิ์จัดการจะไม่แสดงปุ่มแก้ไข/ลบ และ controller ยังตรวจสิทธิ์ซ้ำก่อนเรียก API อีกชั้น

สูตรอาหารใน `db.json` มี field เพิ่ม:

```json
{
  "ownerId": "user-1",
  "ownerName": "นักศึกษา Flutter"
}
```

หมายเหตุ: โปรเจคนี้เก็บรหัสผ่านแบบ plain text ใน `db.json` เพื่อการเรียนรู้ Flutter/json-server เท่านั้น ไม่ควรใช้แนวทางนี้กับระบบจริง

## วิธีเพิ่มรูปใน Assets

ไฟล์ placeholder ถูกสร้างไว้แล้ว:

- `assets/images/logo.png`
- `assets/images/placeholder_food.png`
- `assets/images/default_profile.png`

สามารถแทนที่ไฟล์เหล่านี้ด้วยรูปจริงชื่อเดิมได้ทันที หรือเพิ่มไฟล์ใหม่ใน `assets/images/` แล้วอ้าง path ใน `db.json`

## รายการ Widget และ Syntax ทั้ง 37 ข้อ

1. `Text` และ `TextStyle` - `lib/pages/splash/splash_page.dart`, `lib/widgets/recipe_card.dart`
2. `Icon` - `lib/pages/profile/profile_page.dart`, `lib/widgets/empty_state.dart`
3. `Image.asset()` - `lib/pages/splash/splash_page.dart`, `lib/widgets/recipe_card.dart`
4. `CircleAvatar` - `lib/pages/home/home_page.dart`, `lib/pages/profile/profile_page.dart`
5. `Container` - `lib/pages/home/home_page.dart`, `lib/widgets/recipe_card.dart`
6. `Row` และ `Column` - `lib/pages/home/home_page.dart`, `lib/pages/recipe_form/recipe_form_page.dart`
7. `Expanded` - `lib/widgets/recipe_card.dart`, `lib/pages/profile/profile_page.dart`
8. `Flexible` - `lib/widgets/recipe_card.dart`
9. `Padding` - `lib/pages/home/home_page.dart`, `lib/widgets/empty_state.dart`
10. `SizedBox` - ใช้ทุกหน้าหลัก เช่น `lib/pages/splash/splash_page.dart`
11. `Center` - `lib/pages/splash/splash_page.dart`, `lib/widgets/empty_state.dart`
12. `Align` - `lib/pages/profile/profile_page.dart`
13. `Stack` - `lib/pages/home/home_page.dart`, `lib/pages/recipe_detail/recipe_detail_page.dart`
14. `Positioned` - `lib/pages/home/home_page.dart`, `lib/widgets/recipe_card.dart`
15. `AppBar` - `lib/pages/home/home_page.dart`, `lib/pages/search/search_page.dart`
16. `PreferredSize` - `lib/pages/home/home_page.dart`
17. `ListTile` - `lib/pages/profile/profile_page.dart`, `lib/pages/recipe_detail/recipe_detail_page.dart`
18. `Divider` - `lib/pages/profile/profile_page.dart`, `lib/pages/recipe_detail/recipe_detail_page.dart`
19. `ListView` - `lib/pages/home/home_page.dart`, `lib/pages/search/search_page.dart`
20. `SingleChildScrollView` - `lib/pages/search/search_page.dart`, `lib/pages/recipe_detail/recipe_detail_page.dart`
21. `GestureDetector` - `lib/widgets/category_item.dart`
22. `InkWell` - `lib/widgets/recipe_card.dart`
23. `ElevatedButton` - `lib/pages/recipe_form/recipe_form_page.dart`, `lib/widgets/empty_state.dart`
24. `TextButton` - `lib/pages/recipe_form/recipe_form_page.dart`, `lib/controllers/recipe_controller.dart`
25. `IconButton` - `lib/widgets/recipe_card.dart`, `lib/pages/recipe_detail/recipe_detail_page.dart`
26. `BottomNavigationBar` - `lib/pages/main/main_page.dart`
27. `Navigator.push()` - `lib/routes/app_navigator.dart`
28. `Navigator.pop()` - `lib/pages/recipe_detail/recipe_detail_page.dart`, `lib/pages/recipe_form/recipe_form_page.dart`
29. `setState()` - `lib/pages/recipe_detail/recipe_detail_page.dart`, `lib/pages/recipe_form/recipe_form_page.dart`
30. `initState()` - `lib/pages/splash/splash_page.dart`, `lib/pages/recipe_form/recipe_form_page.dart`
31. `addPostFrameCallback()` - `lib/pages/main/main_page.dart`
32. `GetxController` - `lib/controllers/recipe_controller.dart`
33. `.obs` - `lib/controllers/recipe_controller.dart`, `lib/controllers/navigation_controller.dart`
34. `VoidCallback` - `lib/widgets/recipe_card.dart`, `lib/widgets/empty_state.dart`
35. Custom Widget - `lib/widgets/recipe_card.dart`, `lib/widgets/category_item.dart`
36. `copyWith()` - `lib/models/recipe.dart`, `lib/themes/app_theme.dart`
37. `ScreenUtilInit` - `lib/main.dart`
