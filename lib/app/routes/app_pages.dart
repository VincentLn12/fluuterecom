import 'package:get/get.dart';

import '../bindings/bill_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/maintenance_binding.dart';
import '../bindings/room_binding.dart';
import '../bindings/tenant_binding.dart';
import '../bindings/utility_meter_binding.dart';
import '../routes/app_routes.dart';
import '../views/auth/login_view.dart';
import '../views/bills/bill_detail_view.dart';
import '../views/bills/bill_list_view.dart';
import '../views/main_navigation/main_navigation_view.dart';
import '../views/maintenance/maintenance_view.dart';
import '../views/rooms/room_detail_view.dart';
import '../views/rooms/room_form_view.dart';
import '../views/rooms/room_list_view.dart';
import '../views/settings/settings_view.dart';
import '../views/tenants/tenant_detail_view.dart';
import '../views/tenants/tenant_form_view.dart';
import '../views/tenants/tenant_list_view.dart';
import '../views/utility_meters/utility_meter_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigationView(),
      bindings: [
        DashboardBinding(),
        RoomBinding(),
        TenantBinding(),
        BillBinding(),
        UtilityMeterBinding(),
        MaintenanceBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.rooms,
      page: () => RoomListView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: AppRoutes.roomForm,
      page: () => RoomFormView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: AppRoutes.roomDetail,
      page: () => const RoomDetailView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: AppRoutes.tenants,
      page: () => TenantListView(),
      binding: TenantBinding(),
    ),
    GetPage(
      name: AppRoutes.tenantForm,
      page: () => TenantFormView(),
      binding: TenantBinding(),
    ),
    GetPage(
      name: AppRoutes.tenantDetail,
      page: () => const TenantDetailView(),
      binding: TenantBinding(),
    ),
    GetPage(
      name: AppRoutes.bills,
      page: () => BillListView(),
      binding: BillBinding(),
    ),
    GetPage(
      name: AppRoutes.billDetail,
      page: () => const BillDetailView(),
      binding: BillBinding(),
    ),
    GetPage(
      name: AppRoutes.utilityMeters,
      page: () => UtilityMeterView(),
      binding: UtilityMeterBinding(),
    ),
    GetPage(
      name: AppRoutes.maintenance,
      page: () => MaintenanceView(),
      binding: MaintenanceBinding(),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
  ];
}
