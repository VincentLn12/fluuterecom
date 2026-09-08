# Kanchanaburi Platform — Flutter + GetX

โปรเจค Flutter สำหรับแพลตฟอร์มจังหวัดกาญจนบุรี
พัฒนาต่อยอดจาก `fronendKanchanaburiPlatform` โดยเปลี่ยนจาก Vue 3 + TypeScript มาเป็น Flutter + GetX

ระบบหลักประกอบด้วย

* หน้าแรก
* ร้านค้า
* สินค้า
* เนื้อหา / บทความ
* ตะกร้าสินค้า
* คำสั่งซื้อ
* ชำระเงิน
* โปรไฟล์
* Authentication (เข้าสู่ระบบ / สมัครสมาชิก)
* Merchant / My Shop
* Admin

## Folder Structure

```text
kanchanaburi_platform/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── routes/
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   │
│   │   ├── bindings/
│   │   │   └── initial_binding.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   └── app_theme.dart
│   │   │
│   │   └── config/
│   │       ├── api_config.dart
│   │       └── app_config.dart
│   │
│   ├── core/
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── api_exception.dart
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   └── storage_service.dart
│   │   │
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── app_constants.dart
│   │   │
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── helpers.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_search_field.dart
│   │   │   ├── app_category_chip.dart
│   │   │   ├── app_view_toggle.dart
│   │   │   ├── status_badge.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── empty_widget.dart
│   │   │   └── error_widget.dart
│   │   │
│   │   └── models/
│   │
│   └── features/
│       │
│       ├── navigation/
│       │   ├── controllers/
│       │   │   └── navigation_controller.dart
│       │   ├── bindings/
│       │   │   └── navigation_binding.dart
│       │   └── views/
│       │       └── main_page.dart
│       │
│       ├── home/
│       │   ├── controllers/
│       │   │   └── home_controller.dart
│       │   ├── bindings/
│       │   │   └── home_binding.dart
│       │   ├── views/
│       │   │   └── home_page.dart
│       │   └── widgets/
│       │
│       ├── auth/
│       │   ├── controllers/
│       │   │   └── auth_controller.dart
│       │   ├── bindings/
│       │   │   └── auth_binding.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── views/
│       │       ├── login_page.dart
│       │       └── register_page.dart
│       │
│       ├── shops/
│       │   ├── controllers/
│       │   │   ├── shop_controller.dart
│       │   │   ├── shop_detail_controller.dart
│       │   │   └── product_detail_controller.dart
│       │   ├── bindings/
│       │   │   └── shop_binding.dart
│       │   ├── models/
│       │   │   ├── shop_model.dart
│       │   │   ├── product_model.dart
│       │   │   └── category_model.dart
│       │   ├── repositories/
│       │   │   └── shop_repository.dart
│       │   ├── views/
│       │   │   ├── shops_page.dart
│       │   │   ├── shop_detail_page.dart
│       │   │   ├── products_page.dart
│       │   │   └── product_detail_page.dart
│       │   └── widgets/
│       │       ├── shop_card.dart
│       │       ├── product_card.dart
│       │       └── shop_interactive_map_view.dart
│       │
│       ├── contents/
│       │   ├── controllers/
│       │   │   ├── content_controller.dart
│       │   │   └── content_detail_controller.dart
│       │   ├── bindings/
│       │   │   └── content_binding.dart
│       │   ├── models/
│       │   │   └── content_model.dart
│       │   ├── repositories/
│       │   │   └── content_repository.dart
│       │   ├── views/
│       │   │   ├── contents_page.dart
│       │   │   └── content_detail_page.dart
│       │   └── widgets/
│       │       ├── content_card.dart
│       │       ├── content_video_player.dart
│       │       ├── content_map_widget.dart
│       │       └── content_interactive_map_view.dart
│       │
│       ├── cart/
│       │   ├── controllers/
│       │   │   └── cart_controller.dart
│       │   ├── bindings/
│       │   │   └── cart_binding.dart
│       │   ├── models/
│       │   │   └── cart_item_model.dart
│       │   ├── repositories/
│       │   │   └── cart_repository.dart
│       │   └── views/
│       │       └── cart_page.dart
│       │
│       ├── orders/
│       │   ├── controllers/
│       │   │   └── order_controller.dart
│       │   ├── models/
│       │   │   └── order_model.dart
│       │   ├── repositories/
│       │   │   └── order_repository.dart
│       │   └── views/
│       │       ├── orders_page.dart
│       │       └── order_detail_page.dart
│       │
│       ├── checkout/
│       │   ├── controllers/
│       │   │   └── checkout_controller.dart
│       │   └── views/
│       │       ├── checkout_page.dart
│       │       ├── payment_page.dart
│       │       └── payment_success_page.dart
│       │
│       ├── profile/
│       │   ├── controllers/
│       │   │   └── profile_controller.dart
│       │   ├── bindings/
│       │   │   └── profile_binding.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── views/
│       │       ├── profile_page.dart
│       │       └── edit_profile_page.dart
│       │
│       ├── merchant/
│       │   ├── controllers/
│       │   ├── bindings/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── views/
│       │       ├── register_shop_page.dart
│       │       ├── merchant_dashboard_page.dart
│       │       ├── manage_products_page.dart
│       │       ├── manage_orders_page.dart
│       │       └── manage_contents_page.dart
│       │
│       └── admin/
│           ├── controllers/
│           ├── bindings/
│           ├── models/
│           ├── repositories/
│           └── views/
│               ├── admin_dashboard_page.dart
│               ├── manage_shops_page.dart
│               ├── manage_categories_page.dart
│               ├── manage_contents_page.dart
│               ├── manage_tags_page.dart
│               └── reports_page.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/
│   └── widget_test.dart
│
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

## Bottom Navigation Bar

Navbar หลักของ Application มีทั้งหมด 5 แท็บ

1. **หน้าแรก**
   * `home_page.dart`
   * แสดง Banner
   * ร้านค้าแนะนำ
   * สินค้าแนะนำ
   * เนื้อหา / ข่าวสารล่าสุด

2. **ร้านค้า & ระบบสินค้า (Shops & Product System)**
   * `shops_page.dart`, `shop_detail_page.dart` & `product_detail_page.dart`
   * **Live API Integration**: ดึงข้อมูลร้านค้า หมวดหมู่สินค้า และอำเภอจาก API จริง (`https://coms.kru.ac.th/boatapi/api`)
   * **Dual View Switcher**: สลับการแสดงผลแบบ `📋 รายการร้านค้า` (Grid/List View) และ `🗺️ แผนที่ร้านค้า` (Interactive OpenStreetMap)
   * **Shop Operating Status**: คำนวณเวลาเปิด-ปิดร้านอัตโนมัติ (`isOpenNow`) แสดงสถานะ เปิดบริการอยู่ / ปิดให้บริการ แบบ Real-time
   * **Shop Detail Showcase**: แสดง Banner ปก, โทรออกตรง (`tel:`), ดูตำแหน่งที่ตั้ง และสินค้าทั้งหมดภายในร้าน
   * **Product Detail Page**: แสดงแกลเลอรีรูปภาพสินค้า, ป้ายสถานะคลังสินค้า, ข้อมูลร้านค้าผู้ขาย, เครื่องมือเลือกจำนวน และปุ่มเพิ่มลงตะกร้าพร้อมคำนวณราคารวม

3. **เนื้อหา & แผนที่ท่องเที่ยว (Content & Map)**
   * `contents_page.dart` & `content_detail_page.dart`
   * **API Integration**: ดึงข้อมูลคอนเทนต์ หมวดหมู่ และอำเภอ จาก API จริง (`https://coms.kru.ac.th/boatapi/api`) โดยตรง
   * **Segmented View Switcher**: ปุ่มสลับมุมมองระหว่าง **`📋 รายการบทความ`** (Grid/List Card View) และ **`🗺️ แผนที่ท่องเที่ยว`** (Full Interactive Map View)
   * **Interactive Map View (`content_interactive_map_view.dart`)**: ปักหมุดพิกัดสถานที่จริง (`latitude`, `longitude`) บนแผนที่ OpenStreetMap แบบโต้ตอบได้
   * **Marker BottomSheet & Navigation**: กดที่หมุดบนแผนที่เพื่อดูการ์ดพรีวิว และเปิดนำทางด้วย Google Maps / Apple Maps ได้ทันที
   * **In-App Video Player (`content_video_player.dart`)**: ตัวเล่นวิดีโอ YouTube ในแอป (`youtube_player_flutter`) วางในตำแหน่ง Top Header พร้อมระบบ AutoPlay เมื่อเข้าดูรายละเอียดบทความ

4. **ตะกร้าสินค้า (Shopping Cart System)**
   * `cart_page.dart`, `cart_controller.dart` & `cart_item_model.dart`
   * **Shop-Grouped Display**: จัดกลุ่มรายการสินค้าในตะกร้าแยกตามร้านค้าอัตโนมัติ
   * **Item & Shop Selection**: ระบบเลือกสินค้าแบบ Checkbox รายชิ้น, เลือกทั้งร้านค้า หรือเลือกสินค้าทั้งหมดในตะกร้า
   * **Quantity Stepper & Instant Recalculation**: ปุ่มปรับเพิ่ม/ลดจำนวนสินค้า พร้อมคำนวณราคาย่อย (Subtotal) และราคารวมทั้งหมด (Total Price) แบบ Real-time
   * **Global Permanent State**: เรียกใช้งาน `CartController` ได้จากทุกหน้า (`ProductCard`, `ProductDetailPage`, Bottom Bar)
   * **Empty Cart View & Checkout Navigation**: หน้าการ์ดแจ้งเตือนตะกร้าว่างพร้อมปุ่มทางลัดไปเลือกซื้อสินค้า และแถบสั่งซื้อสินค้าลอยด้านล่าง (Bottom Checkout Bar)

5. **โปรไฟล์ & ระบบสมาชิก (Profile & Authentication System)**
   * `profile_page.dart`, `login_page.dart` & `register_page.dart`
   * **Live OpenAPI Authentication**: เชื่อมต่อ API `/api/login`, `/api/register`, `/api/account/me`, `/api/account/profile`
   * **Automatic Bearer Token Header**: ระบบแนบ `Authorization: Bearer <accessToken>` อัตโนมัติทุก Request ผ่าน `ApiClient` Request Modifier
   * **Dynamic Session Management**: จัดการเซสชันผู้ใช้งานด้วย `AuthService` แสดงผลข้อมูลผู้ใช้, สิทธิ์ (`Role`), ปุ่มแก้ไขโปรไฟล์, ประวัติคำสั่งซื้อ และปุ่มออกจากระบบ

## Navbar Structure

```text
MainPage
│
├── HomePage
├── ShopsPage
├── ContentsPage
├── CartPage
└── ProfilePage
```

ควบคุม Navbar ด้วย

```text
features/navigation/controllers/navigation_controller.dart
```

## GetX Route Structure

Route หลักเก็บไว้ที่

```text
lib/app/routes/
├── app_routes.dart
└── app_pages.dart
```

## Authentication System Feature Highlights

- **OpenAPI Integration**: เชื่อมต่อกับ backend API ความปลอดภัยมาตรฐาน ASP.NET Core Identity (`/api/login`, `/api/register`, `/api/account/me`, `/api/account/profile`)
- **Automated Authorization Headers**: `ApiClient` แนบ Bearer Token ทุก HTTP Call โดยอัตโนมัติเมื่อผู้ใช้เข้าสู่ระบบแล้ว
- **Shared Reusable Form Components**: ใช้ `AppTextField` และ `AppButton` พร้อมฟีเจอร์สลับการมองเห็นรหัสผ่าน (Obscure Password Toggle) และ Loading Indicator
- **Global Auth State (`AuthService`)**: ซิงค์สถานะการล็อกอิน สิทธิ์ผู้ใช้งาน และเปลี่ยนหน้าตาโปรไฟล์แบบ Real-time ข้ามทุกหน้าในแอป
