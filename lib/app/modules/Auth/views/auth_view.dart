import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
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
    final storage = SecureStorageService.instance;
    int? number = Get.arguments;
    if (number == 1) {
      // Show register tab if explicitly requested
      controller.selectLoginOrRegister = true;
    } else {
      // Default: show login tab
      controller.selectLoginOrRegister = false;
    }

    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with logo
            Container(
              height: 205,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorsManager.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppPadding.p25),
                  bottomRight: Radius.circular(AppPadding.p25),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p30),
                  child: Image.asset(
                    ImagesManager.logo,
                    height: 129,
                    width: 128,
                    color: ColorsManager.whiteColor,
                  ),
                ),
              ),
            ),

            // Login/Register toggle and form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    loginOrRegister(context),
                    SizedBox(
                      height: controller.selectLoginOrRegister ? 0 : 20,
                    ),
                    Obx(
                      () => controller.selectLoginOrRegister == true
                          ? const RegisterScreen()
                          : const LoginScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
