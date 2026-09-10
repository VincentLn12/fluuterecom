abstract class AppRoutes {
  static const initial = '/';
  static const login = '/login';
  static const register = '/register';

  static const shops = '/shops';
  static const shopDetail = '/shops/:id';
  static const productDetail = '/products/:id';

  static const contents = '/contents';
  static const createContent = '/contents/create';
  static const contentDetail = '/contents/:id';

  static const cart = '/cart';
  static const checkout = '/checkout';
  static const payment = '/payment';
  static const paymentSuccess = '/payment-success';

  static const orders = '/orders';
  static const orderDetail = '/orders/:id';

  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const myContents = '/profile/my-contents';
  static const favorites = '/profile/favorites';
  static const history = '/profile/history';

  static const registerShop = '/register-shop';
  static const myShop = '/my-shop';
  static const myShopProducts = '/my-shop/products';
  static const myShopOrders = '/my-shop/orders';
  static const myShopContents = '/my-shop/contents';

  static const admin = '/admin';
  static const adminShops = '/admin/shops';
  static const adminCategories = '/admin/categories';
  static const adminContents = '/admin/contents';
  static const adminTags = '/admin/tags';
  static const adminReports = '/admin/reports';
}
