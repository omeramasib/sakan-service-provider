import 'package:get/get.dart';

import '../../../data/providers/config_provider.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigProvider>(() => ConfigProvider());
    Get.lazyPut<SplashScreenController>(
      () => SplashScreenController(),
    );
  }
}
