import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';
import 'package:http/http.dart' as http;

import '../model/service_model.dart';

class DakliaServiceProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static DakliaServiceProvider get instance => Get.put(DakliaServiceProvider());
  GetStorage storage = GetStorage();
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

  Future<List<ServiceModel>> getServiceList(String dakliaId) async {
    final url = '${HttpHelper.baseUrl2}/$dakliaId/services/';

    final response = await get(
      url,
      headers: {
        'Authorization': 'Token ${storage.read('token')}',
      },
    );
    log('${response.body}');
    final statusCode = response.statusCode;
    final data = response.body;

    if (statusCode == 200) {
      final List<ServiceModel> services = [];

      for (final serviceData in data) {
        final service = ServiceModel.fromJson(serviceData);
        services.add(service);
      }

      return services;
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

    if (statusCode == 400) {
      if (data['message'] != "Service does not belong to this Daklia") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'service_not_belong_to_daklia'.tr);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
      if (data['message'] != 'Service does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'service_does_not_exist'.tr);
      }
    }
    return [];
  }

  Future<ServiceModel> addService({
    required String serviceId,
    required String serviceName,
    required String serviceDescription,
    required String serviceType,
    required bool isAvailable,
    required String servicePrice,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    log('this is the service type: $serviceType');
    final response = await post(
      '${HttpHelper.baseUrl2}${HttpHelper.servicesAdd}',
      {
        'daklia_id': storage.read('dakliaId'),
        'service_id': int.parse(serviceId),
        'service_name': serviceName,
        'service_description': serviceDescription,
        'service_type': serviceType,
        'isAvailable': isAvailable,
        'service_price': servicePrice,
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${storage.read('token')}',
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
      storage.write('serviceId', data['service_id']);
      Dialogs.successDialog(Get.context!, 'service_added_successfully'.tr);
      Get.offAllNamed(Routes.SERVICES_MANAGEMENT);
      return ServiceModel.fromJson(data);
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
    return ServiceModel.fromJson(data);
  }

  Future<ServiceModel> editService({
    required int serviceId,
    required String serviceName,
    required String serviceDescription,
    required String serviceType,
    required bool isAvailable,
    required String servicePrice,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final response = await put(
        '${HttpHelper.baseUrl2}/${storage.read('dakliaId')}/services/$serviceId/',
        {
          'service_name': serviceName,
          'service_description': serviceDescription,
          'service_type': serviceType,
          'isAvailable': isAvailable,
          'service_price': servicePrice,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token ${storage.read('token')}',
        });

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, 'services_updated_successfully'.tr);
      Get.offAllNamed(Routes.SERVICES_MANAGEMENT);
      return ServiceModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] != "Service does not belong to this Daklia") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'service_not_belong_to_daklia'.tr);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
      if (data['message'] != 'Service does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'service_does_not_exist'.tr);
      }
    }
    return ServiceModel.fromJson(data);
  }
}
