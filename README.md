# Kanchanaburi Platform — Flutter + GetX

โปรเจค Flutter สำหรับแพลตฟอร์มจังหวัดกาญจนบุรี
พัฒนาต่อยอดจาก `fronendKanchanaburiPlatform` โดยเปลี่ยนจาก Vue 3 + TypeScript มาเป็น Flutter + GetX

ระบบหลักประกอบด้วย

* หน้าแรก
* ร้านค้า
* สินค้า
* เนื้อหา / บทความ
* ตะกร้าสินค้า
* ชำระเงิน / Checkout
* คำสั่งซื้อ
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
│       │   │   └── content_controller.dart
│       │   ├── bindings/
│       │   │   └── content_binding.dart
│       │   ├── models/
│       │   │   └── content_model.dart
│       │   ├── repositories/
│       │   │   └── content_repository.dart
│       │   ├── views/
│       │   │   └── contents_page.dart
│       │   └── widgets/
│       │       ├── content_card.dart
│       │       ├── content_video_player.dart
│       │       ├── content_map_widget.dart
│       │       └── content_interactive_map_view.dart
│       │
│       ├── content_detail/
│       │   ├── controllers/
│       │   │   └── content_detail_controller.dart
│       │   ├── bindings/
│       │   │   └── content_detail_binding.dart
│       │   ├── models/
│       │   │   └── content_detail_model.dart
│       │   ├── repositories/
│       │   │   └── content_detail_repository.dart
│       │   ├── views/
│       │   │   └── content_detail_page.dart
│       │   └── widgets/
│       │       ├── content_detail_hero.dart
│       │       ├── content_detail_header.dart
│       │       ├── content_action_buttons.dart
│       │       ├── content_summary_card.dart
│       │       ├── content_schedule_section.dart
│       │       ├── content_shop_section.dart
│       │       ├── content_product_section.dart
│       │       ├── content_review_section.dart
│       │       └── related_content_section.dart
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
│       ├── checkout/
│       │   ├── controllers/
│       │   │   └── checkout_controller.dart
│       │   ├── bindings/
│       │   │   └── checkout_binding.dart
│       │   └── views/
│       │       ├── checkout_page.dart
│       │       ├── payment_page.dart
│       │       └── payment_success_page.dart
│       │
│       ├── orders/
│       │   ├── controllers/
│       │   │   └── order_controller.dart
│       │   ├── bindings/
│       │   │   └── order_binding.dart
│       │   ├── models/
│       │   │   ├── order_model.dart
│       │   │   └── user_address_model.dart
│       │   ├── repositories/
│       │   │   └── order_repository.dart
│       │   └── views/
│       │       ├── orders_page.dart
│       │       └── order_detail_page.dart
│       │
│       ├── profile/
│       │   ├── controllers/
│       │   │   ├── profile_controller.dart
│       │   │   ├── my_contents_controller.dart
│       │   │   └── favorites_controller.dart
│       │   ├── bindings/
│       │   │   └── profile_binding.dart
│       │   ├── models/
│       │   │   └── favorite_content_model.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── views/
│       │       ├── profile_page.dart
│       │       ├── edit_profile_page.dart
│       │       ├── my_contents_page.dart
│       │       └── favorites_page.dart
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
   * **Dual View Switcher**: สลับการแสดงผลแบบ `📋 รายการร้านค้า` (Grid/List View) และ `🗺️ แผนที่ร้านค้า` (Interactive Map View)
   * **Photo Pin Markers (`shop_interactive_map_view.dart`)**: แสดงหมุดปักรูปภาพร้านค้าจริงบนแผนที่ OpenStreetMap พร้อมปลายหมุดชี้พิกัด และการ์ดพรีวิวร้านค้าเมื่อแตะหมุด
   * **Shop Operating Status**: คำนวณเวลาเปิด-ปิดร้านอัตโนมัติ (`isOpenNow`) แสดงสถานะ เปิดบริการอยู่ / ปิดให้บริการ แบบ Real-time
   * **Shop Detail Showcase**: แสดง Banner ปก, โทรออกตรง (`tel:`), ดูตำแหน่งที่ตั้ง และสินค้าทั้งหมดภายในร้าน
   * **Product Detail Page**: แสดงแกลเลอรีรูปภาพสินค้า, ป้ายสถานะคลังสินค้า, ข้อมูลร้านค้าผู้ขาย, เครื่องมือเลือกจำนวน และปุ่มเพิ�5. **โปรไฟล์ & ระบบสมาชิก (Profile & Authentication System)**
   * `profile_page.dart`, `login_page.dart` & `register_page.dart`
   * **Live OpenAPI Authentication**: เชื่อมต่อ API `/api/login`, `/api/register`, `/api/account/me`, `/api/account/profile`
   * **Automatic Bearer Token Header**: ระบบแนบ `Authorization: Bearer <accessToken>` อัตโนมัติทุก Request ผ่าน `ApiClient` Request Modifier
   * **Full Alignment with Web Repository (`VincentLn12/fronendKanchanaburiPlatform`)**:
     - **Top Breadcrumb Navigation**: แถบนำทาง `หน้าแรก` > `บัญชีของฉัน` พร้อมป้าย `🛡️ ระบบจัดการบัญชี`
     - **Initials Gradient Avatar**: ภาพโปรไฟล์วงกลมแบบไล่เฉดสีแอมเบอร์คอรัล แสดงอักษรย่อชื่อผู้ใช้ (Initials) พร้อมป้ายยืนยันสีเขียว `✓`
     - **Warm Ivory Card Theme**: สีพื้นหลังการ์ด `#FFF9F2` พร้อมเส้นขอบ `#E8D9C9` คุมโทนเหมือนหน้าเว็บสไตล์ทางการ
   * **Product Detail Page**: แสดงแกลเลอรีรูปภาพสินค้า, ป้ายสถานะคลังสินค้า, ข้อมูลร้านค้าผู้ขาย, เครื่องมือเลือกจำนวน และปุ่มเพิ่มสินค้าลงตะกร้า

3. **ระบบเนื้อหา & ข่าวสาร (Content System)**
   * `contents_page.dart` & `content_detail_page.dart`
   * **Live Content API**: เชื่อมต่อบทความท่องเที่ยวจาก API
   * **Map Integration (`content_interactive_map_view.dart`)**: ปักหมุดสถานที่ท่องเที่ยวบนแผนที่ พร้อม Pop-up ข้อมูลสั้นๆ และปุ่มนำทาง
   * **Enhanced Content Detail Redesign (`content_detail_page.dart` & Modular Widgets)**:
     - **16:9 AspectRatio Video Hero (`content_detail_hero.dart`)**: วิดีโอ YouTube อัตราส่วน 16:9 มุมโค้งมน พร้อมระบบ AutoPlay เล่นวิดีโออัตโนมัติเมื่อเข้าสู่บทความ
     - **Magazine Typography Header (`content_detail_header.dart`)**: แสดงหมวดหมู่, เวลาที่ใช้ในการอ่าน, ยอดเข้าชม และวันที่เผยแพร่
     - **Prominent Navigation CTA (`content_action_buttons.dart`)**: ปุ่มเฉดสีส้มไล่ระดับ `นำทางไปยังสถานที่ 📍`, ปุ่มถูกใจ และปุ่มแชร์
     - **Quote Callout Summary (`content_summary_card.dart`)**: การ์ดสรุปเนื้อหาสไตล์บทความนิตยสาร
     - **Schedule Timeline (`content_schedule_section.dart`)**: กำหนดการและช่วงเวลาจัดกิจกรรม
     - **Related Shops Slider (`content_shop_section.dart`)**: สไลเดอร์เลื่อนดูร้านค้าชุมชนที่เกี่ยวข้อง พร้อมป้ายสถานะ `🟢 เปิดบริการ`
     - **OTOP Product Showcase (`content_product_section.dart`)**: แสดงสินค้าชุมชน OTOP ที่เกี่ยวข้อง พร้อมราคา ป้าย `⭐ OTOP` และระบบป้องกัน Layout Overflow
     - **Review & Star Selector (`content_review_section.dart`)**: แสดงคะแนนรีวิว ระบบเลือกดาวรีวิวแบบ responsive (Wrap-based) และรายการรีวิวจากผู้ใช้จริง
     - **Related Articles (`related_content_section.dart`)**: แนะนำบทความท่องเที่ยวอื่น ๆ ที่น่าสนใจ
   - **Typography & Font Scaling**: ปรับขนาดตัวอักษรให้อ่านง่ายสบายตา รองรับการแสดงผลทุกขนาดหน้าจอโดยไม่มีปัญหา Overflow

4. **ตะกร้าสินค้า (Shopping Cart System)**
   * `cart_page.dart`, `cart_controller.dart`, `cart_repository.dart` & `cart_item_model.dart`
   * **Live OpenAPI Cart Integration**: ดึงและซิงค์ข้อมูลตะกร้าสินค้าส่วนตัวของผู้ใช้กับ Backend Database โดยตรง:
     - `GET /api/cart`: ดึงตะกร้าสินค้าของผู้ใช้แต่ละบัญชีแยกกันเป็นเอกเทศ
     - `POST /api/cart/items`: เพิ่มสินค้าลงในตะกร้าบนฐานข้อมูล
     - `PUT /api/cart/items/{id}`: ปรับเปลี่ยนจำนวนสินค้าในตะกร้าบนเซิร์ฟเวอร์
     - `DELETE /api/cart/items/{id}`: ลบสินค้าออกจากตะกร้าบนเซิร์ฟเวอร์
   * **Dynamic Navbar Visibility**: ปรับแต่ง Bottom Navigation Bar ให้ซ่อน/แสดง ไอคอนตะกร้าสินค้าอัตโนมัติขึ้นอยู่กับสถานะการเข้าสู่ระบบ (`authService.isLoggedIn.value`)
   * **Shop-Grouped Display**: จัดกลุ่มรายการสินค้าในตะกร้าแยกตามร้านค้าอัตโนมัติ
   * **Item & Shop Selection**: ระบบเลือกสินค้าแบบ Checkbox รายชิ้น, เลือกทั้งร้านค้า หรือเลือกสินค้าทั้งหมดในตะกร้า
   * **Quantity Stepper & Instant Recalculation**: ปุ่มปรับเพิ่ม/ลดจำนวนสินค้า พร้อมคำนวณราคาย่อย (Subtotal) และราคารวมทั้งหมด (Total Price) แบบ Real-time
   * **Auth-Gated Cart Protection**: หากผู้ใช้ยังไม่ได้เข้าสู่ระบบ จะไม่อนุญาตให้เห็นหรือเข้าถึงตะกร้าสินค้า โดยแสดงหน้าแจ้งเตือนล็อกอิน "กรุณาเข้าสู่ระบบก่อนใช้งานตะกร้าสินค้า" พร้อมปุ่มทางลัดเข้าสู่ระบบ
   * **Auto Sync on Auth Session Change**: โหลดและซิงค์ข้อมูลตะกร้าใหม่อัตโนมัติเมื่อมีการเข้าสู่ระบบ/สลับบัญชีผู้ใช้

5. **โปรไฟล์ & ระบบสมาชิก (Profile & Authentication System)**
   * `profile_page.dart`, `login_page.dart` & `register_page.dart`
   * **Live OpenAPI Authentication**: เชื่อมต่อ API `/api/login`, `/api/register`, `/api/account/me`, `/api/account/profile`
   * **Automatic Bearer Token Header**: ระบบแนบ `Authorization: Bearer <accessToken>` อัตโนมัติทุก Request ผ่าน `ApiClient` Request Modifier
   * **Categorized Profile Layout Structure**:
     - **Header Profile Card**: แสดงภาพอวตาร, ชื่อ, อีเมล, สิทธิ์ และปุ่ม [แก้ไขโปรไฟล์] / [เข้าสู่ระบบ]
     - **กิจกรรมของฉัน**: ปุ่มลัดทางลัด 3 รายการ (`♡ บันทึก`, `🕘 ประวัติคำสั่งซื้อ`, `⭐ รีวิว`)
     - **บัญชีของฉัน**: ข้อมูลส่วนตัว, ความปลอดภัย, การแจ้งเตือน, ที่อยู่ของฉัน
     - **การใช้งาน**: คอนเทนต์ที่บันทึก, ร้านค้าที่ติดตาม / ศูนย์ผู้ขาย, รีวิวของฉัน, Admin Dashboard
     - **อื่น ๆ**: ช่วยเหลือและ FAQ, ข้อกำหนดและนโยบายความเป็นส่วนตัว, เกี่ยวกับแอปพลิเคชัน
   * **ระบบคอนเทนต์ของฉัน (`my_contents_page.dart` & `my_contents_controller.dart`)**:
     - **Full Alignment with Web Repository (`ProfileMyContents.vue` & `MyContentsView.vue`)**:
     - **Hero CTA Banner**: การ์ดส่วนหัวต้อนรับเฉดสีครีมอุ่น `#FFF9F2` พร้อมปุ่ม **"+ สร้างคอนเทนต์ใหม่"** (`#D96C2C`)
     - **Status Badges**: ป้ายบอกสถานะบทความตรงตามเว็บ (🟢 *เผยแพร่แล้ว*, 🟠 *รอตรวจสอบ*, ⚪️ *เก็บถาวร/ฉบับร่าง*)
     - **Automated YouTube Thumbnail Resolver**: ดึงภาพหน้าปกคลิปจากลิงก์ YouTube (`hqdefault.jpg`) หรือภาพปกคอนเทนต์โดยอัตโนมัติ
     - **Status Filter Chips**: ชิปตัวกรองสถานะคอนเทนต์ (*ทั้งหมด*, *เผยแพร่แล้ว*, *รอตรวจสอบ*, *เก็บถาวร*)
     - **Interactive Actions & Confirm Dialog**: ปุ่มกดดูคอนเทนต์ (`AppRoutes.contentDetail`), ปุ่มแก้ไข และปุ่มจัดเก็บถาวร (`archiveContent`) พร้อมกล่องยืนยันก่อนดำเนินการ
     - **Graceful Empty State**: หน้าจอเมื่อยังไม่มีคอนเทนต์พร้อมปุ่ม **"สร้างคอนเทนต์แรกของคุณ"**
   * **ระบบรายการโปรดที่บันทึกไว้ (`favorites_page.dart`, `favorites_controller.dart` & `favorite_content_model.dart`)**:
     - **Full Alignment with Web Repository (`ProfileFavoritesList.vue`)**:
     - **Live OpenAPI Integration**:
       - `GET /api/content-favorites`: โหลดรายการโปรดของผู้ใช้จริงจากฐานข้อมูล
       - `POST /api/content-favorites/{contentId}`: เพิ่มบทความลงรายการโปรด
       - `DELETE /api/content-favorites/{contentId}`: ลบบทความออกจากรายการโปรด
       - `GET /api/content-favorites/{contentId}`: ตรวจสอบสถานะว่ากดโปรดแล้วหรือไม่ (`isFavorite`)
     - **Hero Header Banner**: แบนเนอร์หัวข้อสีครีมอุ่น `#FFF9F2` พร้อมสัญลักษณ์หัวใจสีส้มคอรัล `#E76F51`
     - **Interactive Card & Confirm Dialog**: การ์ดแสดงรูปภาพ (หรือ YouTube Thumbnail), ชื่อเรื่อง, เรื่องย่อ, วันที่บันทึก พร้อมปุ่ม **"อ่านบทความ"** และปุ่มลบรายการโปรดพร้อม Pop-up ยืนยัน
     - **Empty State**: หน้าแสดงสถานะเมื่อยังไม่มีรายการโปรด พร้อมปุ่มทางลัด **"สำรวจคอนเทนต์ท่องเที่ยว"**
   * **Guest Unauthenticated Access Control**: หากผู้ใช้ยังไม่ได้เข้าสู่ระบบ จะปรับเป็น Guest Avatar พร้อมซ่อนปุ่มออกจากระบบ และเมื่อกดเลือกเมนูที่ต้องใช้บัญชี (เช่น ประวัติคำสั่งซื้อ หรือข้อมูลส่วนตัว) ระบบจะแสดงป็อปอัปแจ้งเตือนให้เข้าสู่ระบบก่อนอย่างเป็นมิตร

## Checkout & Payment System Feature Highlights

- **Live Checkout API**: เชื่อมต่อ API `POST /api/orders/checkout` ส่งรายการสั่งซื้อ ชนิดการจัดส่ง (`shippingMethod`), ค่าจัดส่ง (`shippingFee`), ข้อมูลผู้รับ และที่อยู่จัดส่ง
- **Saved User Address Picker**: ดึงที่อยู่อิสระของผู้ใช้จาก `GET /api/user-addresses` พร้อมระบบเลือกเติมข้อมูลอัตโนมัติ
- **Dynamic Shipping Options**: เลือกรูปแบบการจัดส่ง (Standard Delivery ฿40 vs Express Delivery ฿60) พร้อมคำนวณยอดสุทธิตามจริง
- **Official Stripe SDK (`flutter_stripe`)**: รวม UI หลักอย่างเป็นทางการของ Stripe:
  - **Stripe PaymentSheet (Native UI)**: หน้าต่างป็อปอัปชำระเงินของ Stripe Native Sheet (`Stripe.instance.presentPaymentSheet()`)
  - **Stripe CardFormField Widget**: Component กรอกข้อมูลบัตรเครดิต/เดบิตอย่างเป็นทางการของ Stripe SDK (`CardFormField`)
- **Stripe Credit/Debit Card Gateway (`PaymentPage`)**: เชื่อมต่อ `POST /api/payments/orders/{orderId}/intent` และ `POST /api/payments/orders/{orderId}/sync` พร้อมระบบความปลอดภัย SSL 256-bit
- **Real Image Picker Slip Upload (`image_picker`)**: ปุ่มเลือกสลิปจริงจากคลังรูปภาพในเครื่อง (`ImageSource.gallery`) พร้อมการ์ดแสดงตัวอย่างรูปสลิปและเวลาอัปโหลด
- **Admin Verification Flow**: ส่งรูปสลิปและอัปเดตสถานะออเดอร์ไปยัง `PATCH /api/orders/{id}/status` เป็น `PendingVerify` สำหรับ Admin ตรวจสอบผ่าน `GET /api/orders/admin/pending-slips` & `POST /api/orders/admin/verify-slip`
- **Payment Success View (`PaymentSuccessPage`)**: หน้าแสดงความยินดีทำรายการสำเร็จ พร้อมปุ่มไปดูประวัติคำสั่งซื้อ (`OrdersPage`)

## Orders & Order Details System Redesign Highlights

- **Shopee-Style Order Status Tabs (`OrdersPage`)**:
  - แถบสลับสถานะคำสั่งซื้อแบบแนวนอน 6 แท็บ: `ทั้งหมด`, `รอชำระเงิน`, `กำลังจัดเตรียม`, `จัดส่งแล้ว`, `สำเร็จ`, `ยกเลิก`
  - ป้ายแสดงจำนวนออเดอร์ (Count Badge) ประจำแต่ละแท็บแบบ Real-time
  - การ์ดคำสั่งซื้อดีไซน์ E-Commerce แยกส่วนหัวร้านค้า, รายการสินค้าย่อย, สถานะออเดอร์, และปุ่มทางลัด "ดูรายละเอียด" / "ชำระเงิน"
- **Modern Order Detail Page (`OrderDetailPage`)**:
  - **Contextual Status Banner**: แถบป้ายสถานะด้านบนปรับเปลี่ยนสี ไอคอน และคำอธิบายตามสถานะคำสั่งซื้อจริง พร้อมแสดงเวลาสั่งซื้อ
  - **Recipient Shipping Address**: แสดงชื่อผู้รับ, เบอร์โทรศัพท์ติดต่อ และที่อยู่จัดส่งแบบการ์ดสะอาดตา
  - **Shop & Ordered Items Breakdown**: แสดงชื่อร้านค้า พร้อมปุ่มกด **"ดูร้านค้า"** นำทางไปยังหน้าร้านค้านั้นๆ ได้ทันที และแสดงรูปภาพ/ราคาสินค้าแต่ละรายการ
  - **Payment Breakdown & Slip Preview**: สรุปยอดรวมสินค้า ค่าจัดส่ง ยอดชำระสุทธิ และป็อปอัปสไลด์เปิดดูรูปสลิปหลักฐานการชำระเงินขนาดใหญ่

