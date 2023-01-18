import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/images_manager.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: Center(
        child: Image.asset(
          ImagesManager.logo,
          width: 188,
          height: 188,
          color: ColorsManager.whiteColor,
        ),
      ),
    );
  }
}
