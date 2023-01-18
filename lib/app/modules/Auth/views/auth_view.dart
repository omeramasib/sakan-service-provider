import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/values_manager.dart';
import '../controllers/auth_controller.dart';
import '../login/login.screen.dart';
import '../register/register.screen.dart';
import '../widgets/choose_login_or_register.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final storage = GetStorage();
    int? number = Get.arguments;
    if (number == 0) {
      controller.selectLoginOrRegister = false;
    } else {
      controller.selectLoginOrRegister = true;
    }
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: Builder(builder: (context) {
        return Column(
          children: [
             Container(
                height: 205,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: ColorsManager.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppPadding.p25),
                    bottomRight: Radius.circular(AppPadding.p25),
                  ),
                ),
               child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppPadding.p30,
                    ),
                    child: Image.asset(
                      ImagesManager.logo,
                      height: 129,
                      width: 128,
                      color: ColorsManager.whiteColor,
                    ),
                  ),
                ),
             ),
            // const SizedBox(
            //   height: 10,
            // ),
            Expanded(
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: ColorsManager.whiteColor,
                ),
                child: Column(
                  children: [
                    loginOrRegister(context),
                    SizedBox(
                      height: controller.selectLoginOrRegister ? 0 : 20,
                    ),
                    Expanded(
                      child: Column(children: [
                        Obx( 
                          () => controller.selectLoginOrRegister == true
                              ? const RegisterScreen()
                              : const LoginScreen(),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
