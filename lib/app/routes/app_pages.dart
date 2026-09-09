import 'package:get/get.dart';
import 'app_routes.dart';

import '../../features/navigation/bindings/navigation_binding.dart';
import '../../features/navigation/views/main_page.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_page.dart';
import '../../features/auth/views/register_page.dart';
import '../../features/shops/bindings/shop_binding.dart';
import '../../features/shops/views/shops_page.dart';
import '../../features/shops/views/shop_detail_page.dart';
import '../../features/shops/views/product_detail_page.dart';
import '../../features/contents/bindings/content_binding.dart';
import '../../features/contents/views/contents_page.dart';
import '../../features/content_detail/bindings/content_detail_binding.dart';
import '../../features/content_detail/views/content_detail_page.dart';
import '../../features/cart/bindings/cart_binding.dart';
import '../../features/cart/views/cart_page.dart';
import '../../features/checkout/bindings/checkout_binding.dart';
import '../../features/checkout/views/checkout_page.dart';
import '../../features/checkout/views/payment_page.dart';
import '../../features/checkout/views/payment_success_page.dart';
import '../../features/orders/bindings/order_binding.dart';
import '../../features/orders/views/orders_page.dart';
import '../../features/orders/views/order_detail_page.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/views/profile_page.dart';
import '../../features/profile/views/edit_profile_page.dart';
import '../../features/profile/views/my_contents_page.dart';
import '../../features/profile/views/favorites_page.dart';
import '../../features/merchant/views/register_shop_page.dart';
import '../../features/merchant/views/merchant_dashboard_page.dart';
import '../../features/merchant/views/manage_products_page.dart';
import '../../features/merchant/views/manage_orders_page.dart';
import '../../features/merchant/views/manage_contents_page.dart';
import '../../features/admin/views/admin_dashboard_page.dart';
import '../../features/admin/views/manage_shops_page.dart';
import '../../features/admin/views/manage_categories_page.dart';
import '../../features/admin/views/manage_contents_page.dart';
import '../../features/admin/views/manage_tags_page.dart';
import '../../features/admin/views/reports_page.dart';

class AppPages {
  static const initial = AppRoutes.initial;

  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const MainPage(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.shops,
      page: () => const ShopsPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.contents,
      page: () => const ContentsPage(),
      binding: ContentBinding(),
    ),
    GetPage(
      name: AppRoutes.contentDetail,
      page: () => const ContentDetailPage(),
      binding: ContentDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: CheckoutBinding(),
    ),
    GetPage(name: AppRoutes.payment, page: () => const PaymentPage()),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessPage(),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersPage(),
      binding: OrderBinding(),
    ),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailPage()),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.myContents,
      page: () => const MyContentsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesPage(),
      binding: ProfileBinding(),
    ),
    GetPage(name: AppRoutes.registerShop, page: () => const RegisterShopPage()),
    GetPage(name: AppRoutes.myShop, page: () => const MerchantDashboardPage()),
    GetPage(
      name: AppRoutes.myShopProducts,
      page: () => const ManageProductsPage(),
    ),
    GetPage(name: AppRoutes.myShopOrders, page: () => const ManageOrdersPage()),
    GetPage(
      name: AppRoutes.myShopContents,
      page: () => const ManageMerchantContentsPage(),
    ),
    GetPage(name: AppRoutes.admin, page: () => const AdminDashboardPage()),
    GetPage(name: AppRoutes.adminShops, page: () => const ManageShopsPage()),
    GetPage(
      name: AppRoutes.adminCategories,
      page: () => const ManageCategoriesPage(),
    ),
    GetPage(
      name: AppRoutes.adminContents,
      page: () => const ManageAdminContentsPage(),
    ),
    GetPage(name: AppRoutes.adminTags, page: () => const ManageTagsPage()),
    GetPage(name: AppRoutes.adminReports, page: () => const ReportsPage()),
  ];
}
