import 'dart:async';

import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {

    startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, await Get.toNamed(Routes.HOME));
  }

    Future<void> navigationPage() async {
    // bool isFirstTime = await getPrefrenceBool(isLogin);
    await Get.toNamed('/home');
    // if (isFirstTime) {
    //   Navigator.pushReplacement(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const Home(),
    //     ),
    //   );
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const Login(),
    //     ),
    //   );
    // }
  }

  @override
  void onInit() {
    super.onInit();
    // startTime();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


}
