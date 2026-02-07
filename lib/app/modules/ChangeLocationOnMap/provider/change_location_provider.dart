import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../dakliaProfile/model/daklia_profile_model.dart';
import '../model/change_location_model.dart';

class ChangeLocationProvider extends GetConnect {
  static ChangeLocationProvider get instance =>
      Get.put(ChangeLocationProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  // var networkController = Get.put(NetworkController());
  Timer? timer;
  @override
  void onInit() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<ChangeLocationModel> changeAddress({
    required String longitude,
    required String latitude,
    required String address,
    required String additonal_address,
  }) async {
    final token = await storage.read('token');
    final userId = await storage.read('userId');
    final locationId = await storage.read('locationId');
    final dakliaId = await storage.read('dakliaId');

    print('DEBUG Provider: locationId = $locationId, dakliaId = $dakliaId');

    Response response;

    // If locationId is null, create a new location with POST
    // Otherwise, update existing location with PUT
    if (locationId == null || locationId == 'null' || locationId.isEmpty) {
      print('DEBUG Provider: Creating NEW location (POST)');
      response =
          await post('${HttpHelper.baseUrl2}${HttpHelper.dakliaLocation}', {
        'user_id': userId,
        'daklia_id': dakliaId,
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
        'additional_address': additonal_address,
      }, headers: {
        'Authorization': 'Token $token',
      });
    } else {
      print('DEBUG Provider: Updating EXISTING location (PUT)');
      response = await put(
          '${HttpHelper.baseUrl2}${HttpHelper.dakliaLocation}$locationId/', {
        'user_id': userId,
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
        'additional_address': additonal_address,
      },
          headers: {
            'Authorization': 'Token $token',
          });
    }

    // print the request url
    print('DEBUG Provider: URL = ${response.request?.url}');
    var data = response.body;
    var statusCode = response.statusCode;
    print('DEBUG Provider: Status code = $statusCode');
    print('DEBUG Provider: Response data = $data');
    EasyLoading.show(status: 'loading'.tr);

    if (statusCode == 200 || statusCode == 201) {
      // If we created a new location, save the new locationId
      if (data != null && data['id'] != null) {
        await storage.write('locationId', data['id'].toString());
        print('DEBUG Provider: Saved new locationId = ${data['id']}');
      }

      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Get.offAllNamed(Routes.HOME);
      Dialogs.successDialog(Get.context!, 'success_change_location'.tr);
      return ChangeLocationModel.fromJson(data);
    }

    if (statusCode == 400) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'invalid_data'.tr);
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    // Return empty model for error cases to avoid parsing errors
    return ChangeLocationModel();
  }
}
