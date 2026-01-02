import 'package:get/get.dart';

import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/resetpassword/bindings/resetpassword_binding.dart';
import '../modules/Auth/resetpassword/views/reset_password_view.dart';
import '../modules/Auth/views/auth_view.dart';
import '../modules/ChangeLocationOnMap/bindings/change_location_on_map_binding.dart';
import '../modules/ChangeLocationOnMap/views/change_location_on_map_view.dart';
import '../modules/MoreScreen/bindings/more_screen_binding.dart';
import '../modules/MoreScreen/views/more_screen_view.dart';
import '../modules/MyAppointments/bindings/my_appointments_binding.dart';
import '../modules/MyAppointments/views/my_appointments_view.dart';
import '../modules/completeDakliaAccount1/bindings/complete_daklia_account1_binding.dart';
import '../modules/completeDakliaAccount1/views/complete_daklia_account1_view.dart';
import '../modules/completeDakliaAccount2/bindings/complete_daklia_account2_binding.dart';
import '../modules/completeDakliaAccount2/views/complete_daklia_account2_view.dart';
import '../modules/completeDakliaAccount3/bindings/complete_daklia_account3_binding.dart';
import '../modules/completeDakliaAccount3/views/complete_daklia_account3_view.dart';
import '../modules/dakliaProfile/bindings/daklia_profile_binding.dart';
import '../modules/dakliaProfile/views/daklia_profile_view.dart';
import '../modules/edit_daklia_profile/bindings/edit_daklia_profile_binding.dart';
import '../modules/edit_daklia_profile/views/edit_daklia_profile_view.dart';
import '../modules/edit_multiple_room/bindings/edit_multiple_room_binding.dart';
import '../modules/edit_multiple_room/views/edit_multiple_room_view.dart';
import '../modules/edit_room_feature/bindings/edit_room_feature_binding.dart';
import '../modules/edit_room_feature/views/edit_room_feature_view.dart';
import '../modules/edit_single_room/bindings/edit_single_room_binding.dart';
import '../modules/edit_single_room/views/edit_single_room_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/network/bindings/network_binding.dart';
import '../modules/network/views/network_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/regulations_management/bindings/regulations_management_binding.dart';
import '../modules/regulations_management/views/regulations_management_view.dart';
import '../modules/room_management/bindings/room_management_binding.dart';
import '../modules/room_management/views/room_management_view.dart';
import '../modules/services_management/bindings/services_management_binding.dart';
import '../modules/services_management/views/services_management_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
      children: [
        GetPage(
          name: _Paths.RESETPASSWORD,
          page: () => const ResetpasswordView(),
          binding: ResetpasswordBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_DAKLIA_ACCOUNT1,
      page: () => const CompleteDakliaAccount1View(),
      binding: CompleteDakliaAccount1Binding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_DAKLIA_ACCOUNT2,
      page: () => const CompleteDakliaAccount2View(),
      binding: CompleteDakliaAccount2Binding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_DAKLIA_ACCOUNT3,
      page: () => const CompleteDakliaAccount3View(),
      binding: CompleteDakliaAccount3Binding(),
    ),
    GetPage(
      name: _Paths.DAKLIA_PROFILE,
      page: () => const DakliaProfileView(),
      binding: DakliaProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DAKLIA_PROFILE,
      page: () => const EditDakliaProfileView(),
      binding: EditDakliaProfileBinding(),
    ),
    GetPage(
      name: _Paths.ROOM_MANAGEMENT,
      page: () => const RoomManagementView(),
      binding: RoomManagementBinding(),
    ),
    GetPage(
      name: _Paths.SERVICES_MANAGEMENT,
      page: () => const ServicesManagementView(),
      binding: ServicesManagementBinding(),
    ),
    GetPage(
      name: _Paths.REGULATIONS_MANAGEMENT,
      page: () => const RegulationsManagementView(),
      binding: RegulationsManagementBinding(),
    ),
    GetPage(
      name: _Paths.MY_APPOINTMENTS,
      page: () => const MyAppointmentsView(),
      binding: MyAppointmentsBinding(),
    ),
    GetPage(
      name: _Paths.MORE_SCREEN,
      page: () => const MoreScreenView(),
      binding: MoreScreenBinding(),
    ),
    GetPage(
      name: _Paths.NETWORK,
      page: () => const NetworkView(),
      binding: NetworkBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_LOCATION_ON_MAP,
      page: () => const ChangeLocationOnMapView(),
      binding: ChangeLocationOnMapBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SINGLE_ROOM,
      page: () => const EditSingleRoomView(),
      binding: EditSingleRoomBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_MULTIPLE_ROOM,
      page: () => const EditMultipleRoomView(),
      binding: EditMultipleRoomBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ROOM_FEATURE,
      page: () => const EditRoomFeatureView(),
      binding: EditRoomFeatureBinding(),
    ),
  ];
}
