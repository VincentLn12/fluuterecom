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
* Authentication
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
│       │   │   └── shop_detail_controller.dart
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

2. **ร้านค้า**
   * `shops_page.dart`
   * รายการร้านค้า
   * ค้นหาร้าน
   * Filter ร้านตามหมวดหมู่
   * ดูรายละเอียดร้าน
   * ดูสินค้า

3. **เนื้อหา**
   * `contents_page.dart`
   * บทความ
   * ข่าวสาร
   * กิจกรรม
   * Content Detail

4. **ตะกร้า**
   * `cart_page.dart`
   * รายการสินค้าในตะกร้า
   * เพิ่ม / ลดจำนวน
   * ลบสินค้า
   * Checkout
   * Payment

5. **โปรไฟล์**
   * `profile_page.dart`
   * ข้อมูลผู้ใช้งาน
   * แก้ไขโปรไฟล์
   * ประวัติคำสั่งซื้อ
   * จัดการร้านค้า
   * Login / Logout

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
