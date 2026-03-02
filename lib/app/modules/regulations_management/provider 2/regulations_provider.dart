import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';
import '../model/regulations_model.dart';

class DakliaRegulationsProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static DakliaRegulationsProvider get instance =>
      Get.put(DakliaRegulationsProvider());
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

  Future<List<DakliaLawsModel>> getLawsList(String dakliaId) async {
    final url = '${HttpHelper.baseUrl2}/$dakliaId/laws/';

    final token = await storage.read('token');
    final response = await get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );
    log('${response.body}');
    final statusCode = response.statusCode;
    final data = response.body;

    if (statusCode == 200) {
      final List<DakliaLawsModel> lawsList = [];

      for (final lawsData in data) {
        final laws = DakliaLawsModel.fromJson(lawsData);
        lawsList.add(laws);
      }

      return lawsList;
    }
    if (statusCode == 401) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }
    if (response.statusCode == 500 ||
        response.statusCode == 502 ||
        response.statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
    }
    return [];
  }

  Future<DakliaLawsModel> addLaw({
    required String lawDescription,
    required String punishmentDescription,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final response = await post(
      '${HttpHelper.baseUrl2}/$dakliaId/laws/add/',
      {
        'daklia_id': dakliaId,
        'law_description': lawDescription,
        'punishment_description': punishmentDescription,
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    // print the request
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the request: ${response.request}');
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('lawId', data['law_id']?.toString());
      Dialogs.successDialog(Get.context!, 'law_added_successfully'.tr);
      Get.offAllNamed(Routes.REGULATIONS_MANAGEMENT);
      return DakliaLawsModel.fromJson(data);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
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
    return DakliaLawsModel.fromJson(data);
  }

  Future<DakliaLawsModel> editLaw({
    required int lawId,
    required String lawDescription,
    required String punishmentDescription,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final response = await put(
      '${HttpHelper.baseUrl2}/$dakliaId/laws/$lawId/',
      {
        'law_description': lawDescription,
        'punishment_description': punishmentDescription,
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, 'law_edited_successfully'.tr);
      Get.offAllNamed(Routes.REGULATIONS_MANAGEMENT);
      return DakliaLawsModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] != "Law does not belong to this Daklia") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'law_not_belong_to_daklia'.tr);
      }
    }

    if (statusCode == 401) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }

    if (statusCode == 404) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
      if (data['message'] != 'Law does not exist') {
        timer = Timer(
          const Duration(seconds: 1),
          () {
            EasyLoading.dismiss();
          },
        );
        Dialogs.errorDialog(Get.context!, 'law_does_not_exist'.tr);
      }
    }
    return DakliaLawsModel.fromJson(data);
  }

  deleteLaw(String dakliaId, String lawId) async {
    final token = await storage.read('token');
    final response = await delete(
      '${HttpHelper.baseUrl2}/$dakliaId/laws/$lawId/delete/',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200 || statusCode == 204) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, 'laws_deleted_successfully'.tr);
      Get.offAllNamed(Routes.REGULATIONS_MANAGEMENT);
    }

    if (statusCode == 400) {
      if (data['message'] != "Law does not belong to this Daklia") {
        timer = Timer(
          const Duration(seconds: 1),
          () {
            EasyLoading.dismiss();
          },
        );
        Dialogs.errorDialog(Get.context!, 'law_not_belong_to_daklia'.tr);
      }
    }

    if (statusCode == 401) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
      if (data['message'] != 'Law does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'law_does_not_exist'.tr);
      }
    }
  }
}
