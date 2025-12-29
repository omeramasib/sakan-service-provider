import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/app/modules/Auth/otp/otp.screen.dart';
import '../../../helpers/fcm_helper.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/login_model.dart';

class LoginProvider extends GetConnect {
  static LoginProvider get instance => Get.put(LoginProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  Timer? timer;

  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.baseUrl;
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<LoginModel> loginUser({
    required String phone,
    required String password,
  }) async {
    final url = HttpHelper.baseUrl + HttpHelper.login;
    print('========== LOGIN REQUEST ==========');
    print('URL: $url');
    print('Phone: $phone');
    print('Password: $password');
    print('===================================');

    try {
      final response = await post(
        url,
        {
          'phone_number': phone,
          'password': password,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      var data = response.body;
      var statusCode = response.statusCode;
      debugPrint('========== LOGIN RESPONSE ==========');
      debugPrint('Status Code: $statusCode');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Data: $data');
      debugPrint('Headers: ${response.headers}');
      debugPrint('====================================');

      if (statusCode == 200) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        await storage.write('token', data['token'].toString());
        await storage.write('userId', data['id'].toString());
        await storage.write('phone', data['phone_number'].toString());

        debugPrint('>>> DEBUG: user_type = ${data['user_type']}');
        debugPrint('>>> DEBUG: Daklia_id = ${data['Daklia_id']}');

        if (data['user_type'] == 1) {
          debugPrint('>>> DEBUG: User is Daklia owner (type 1)');
          if (data['Daklia_id'] != null) {
            debugPrint(
                '>>> DEBUG: Daklia_id is NOT null, calling FCMHelper...');
            await storage.write('dakliaId', data['Daklia_id'].toString());
            Get.offAllNamed(Routes.HOME);
            FCMHelper.instance.updateFCMToken();
            debugPrint('>>> DEBUG: FCMHelper.updateFCMToken() was called');
            Dialogs.successDialog(Get.context!, 'login_success'.tr);
          }
          if (data['Daklia_id'] == null) {
            debugPrint(
                '>>> DEBUG: Daklia_id is NULL, redirecting to complete account');
            Get.offAllNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
          }
        } else {
          debugPrint(
              '>>> DEBUG: User is NOT Daklia owner (type ${data['user_type']})');
        }
        if (data['user_type'] == 0 || data['user_type'] == 2) {
          Dialogs.errorDialog(Get.context!, 'user_not_allowed'.tr);
        }
        return LoginModel.fromJson(data);
      }

      if (statusCode == 400) {
        if (data['message'] == 'Wrong password') {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          Dialogs.errorDialog(Get.context!, 'login_failed'.tr);
        }

        if (data['message'] == 'Account does not verified') {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          await storage.write('phone', phone);
          Dialogs.errorDialog(Get.context!, 'user_not_verified'.tr);
          Get.to(OtpScreen(), arguments: 2);
        }
      }

      if (statusCode == 401) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        if (data['message'] == 'Account does not active') {
          Dialogs.errorDialog(Get.context!, 'user_not_active'.tr);
        } else if (data['message'] == 'Wrong password' ||
            data['message'] == 'Invalid password' ||
            data['message'] == 'Incorrect password') {
          Dialogs.errorDialog(Get.context!, 'login_failed'.tr);
        } else {
          // Handle other 401 errors
          debugPrint('401 Error: ${data['message']}');
          Dialogs.errorDialog(
              Get.context!, data['message']?.toString() ?? 'login_failed'.tr);
        }
      }

      if (statusCode == 404) {
        if (data['message'] == 'User does not exist') {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
        } else {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
        }
      }

      if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
        timer = Timer(
          const Duration(seconds: 1),
          () {
            EasyLoading.dismiss();
          },
        );
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
      }

      return LoginModel.fromJson(data ?? {});
    } catch (e, stackTrace) {
      debugPrint('========== LOGIN ERROR ==========');
      debugPrint('Exception: $e');
      debugPrint('Stack Trace: $stackTrace');
      debugPrint('=================================');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'Connection error: $e');
      return LoginModel();
    }
  }
}
