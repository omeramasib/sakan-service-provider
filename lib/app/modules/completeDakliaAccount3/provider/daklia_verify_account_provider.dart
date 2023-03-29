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
import '../model/daklia_verify_account_model.dart';

class DakliaVAProvider extends GetConnect {
  static DakliaVAProvider get instance => Get.put(DakliaVAProvider());
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

  Future<DakliaVerifyAccountModel> sendVA({
    required File? daklia_license,
    required File? owner_license,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        HttpHelper.baseUrl2 + HttpHelper.verifyAccount,
      ),
    );
    request.headers["authorization"] = "Token ${storage.read('token')}";
    request.fields['Daklia_id'] = storage.read('dakliaId').toString();
    final file1 = await http.MultipartFile.fromBytes(
      'daklia_license',
      daklia_license!.readAsBytesSync(),
      filename: daklia_license.path.split('/').last,
    );
    final file2 = await http.MultipartFile.fromBytes(
      'owner_idenfication_card',
      owner_license!.readAsBytesSync(),
      filename: owner_license.path.split('/').last,
    );
    request.files.add(file1);
    request.files.add(file2);

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });

      Dialogs.successDialog(Get.context!, 'sucsses_submit_confirm_account'.tr);
      Get.toNamed(Routes.DAKLIA_PROFILE);
      return DakliaVerifyAccountModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] == "Daklia ID does not match") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
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
    return DakliaVerifyAccountModel.fromJson(data);
  }
}
