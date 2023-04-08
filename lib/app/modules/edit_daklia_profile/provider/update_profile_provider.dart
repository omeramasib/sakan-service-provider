import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';

class UpdateProfileProvider extends GetConnect {
  static UpdateProfileProvider get instance => Get.put(UpdateProfileProvider());
  GetStorage storage = GetStorage();
  // var networkController = Get.put(NetworkController());
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

  Future<void> updateProfile({
    required File? image,
    required String dakliaDescription,
    required int numberOfRooms,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
    //  '${HttpHelper.baseUrl2}/${storage.read('dakliaId')}${HttpHelper.updateProfile}}'
    'https://sakanapp.onrender.com/api/v1/daklia/${storage.read('dakliaId')}/update-profile/'
      ),
    );
    // print the request
    log('this is the request: $request');
    request.headers["authorization"] = "Token ${storage.read('token')}";
    request.files.add(await http.MultipartFile.fromPath(
      'daklia_image',
      image!.path,
    ));
    request.fields['daklia_description'] = dakliaDescription;
    request.fields['numberOfRooms'] = numberOfRooms.toString();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      log('this is the statusCode : $statusCode' );
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, "success_update_profile".tr);
      Get.offAllNamed(Routes.DAKLIA_PROFILE);
    }

    if (statusCode == 400) {
      if (data['message'] != 'Daklia is already exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_id_already_exist'.tr);
      }

      if (data['user_id'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_id_already_exist'.tr);
      }
      if (data['daklia_image'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_image_required'.tr);
      }

      if (data['daklia_description'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_description_required'.tr);
      }
    }

    if (statusCode == 401) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
  }
}
