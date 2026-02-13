import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../model/daklia_profile_model.dart';

class DakliaProfileProvider {
  static DakliaProfileProvider get instance => Get.put(DakliaProfileProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  Timer? timer;

  Future<DakliaProfileModel?> getProfileInfo(String? id) async {
    try {
      final token = await storage.read('token');
      final url = HttpHelper.baseUrl.replaceAll('/user', '/daklia') +
          HttpHelper.dakliaProfile +
          '$id';

      print('DEBUG Provider: Calling URL: $url');
      print('DEBUG Provider: Token: ${token?.substring(0, 10)}...');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          EasyLoading.dismiss();
          Dialogs.errorDialog(Get.context!, 'connection_timeout'.tr);
          throw TimeoutException(
              'Request timeout', const Duration(seconds: 30));
        },
      );

      var statusCode = response.statusCode;
      final body = response.body;

      log('this is the status code: $statusCode');
      print('DEBUG Provider: Status code: $statusCode');

      // Only parse as JSON when response looks like JSON (server may return HTML for errors)
      Map<String, dynamic>? data;
      if (body.trim().isNotEmpty && !body.trim().toLowerCase().startsWith('<')) {
        try {
          data = jsonDecode(body) as Map<String, dynamic>?;
        } catch (_) {
          log('Profile response is not valid JSON (e.g. HTML error page)');
        }
      }
      if (data != null) {
        log('Profile data: $data');
        print('DEBUG Provider: Response body: $data');
      }

      if (statusCode == 200 && data != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
          storage.write('locationId', data!['location_id']?.toString());
        });
        return DakliaProfileModel.fromJson(data);
      }

      if (statusCode == 401) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
      }
      if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        if (data != null &&
            data.toString().contains('daklia_image') &&
            data.toString().contains('no file associated')) {
          Dialogs.errorDialog(Get.context!, 'profile_image_missing'.tr);
        } else {
          Dialogs.errorDialog(Get.context!, 'server_error'.tr);
        }
      }

      if (statusCode == 404) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
      }

      // Non-200 or non-JSON response (e.g. HTML error page)
      if (data == null && statusCode != 401 && statusCode != 404) {
        EasyLoading.dismiss();
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
      }

      return null;
    } catch (e) {
      log('Error in getProfileInfo: $e');
      print('DEBUG Provider: Error: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'network_error'.tr);
      return null;
    }
  }
}
