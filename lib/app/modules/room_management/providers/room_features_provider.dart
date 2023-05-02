import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sakan/app/modules/room_management/controllers/room_management_controller.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../../widgets/room_management/room_features/room_features.dart';
import '../../../routes/app_pages.dart';
import '../models/add_room_model.dart';
import '../models/room_features_model.dart';

class RoomFeaturesProvider extends GetConnect {
  static RoomFeaturesProvider get instance => Get.put(RoomFeaturesProvider());
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

  // make method to get all features
  Future<List<RoomFeaturesModel>> getAllFeatures({
    required String roomId,
  }) async {
    return await get(
        '${HttpHelper.baseUrl2}/${storage.read('dakliaId')}${HttpHelper.rooms}$roomId/features/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token ${storage.read('token')}',
        }).then((response) {
      var data = response.body;
      var statusCode = response.statusCode;
      log('this is the status code: $statusCode');
      log('this is the data: $data');

      if (statusCode == 200) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });

        final List<dynamic> featuresData = response.body;
        log('this is the features data: $featuresData');
        final List<RoomFeaturesModel> features = [];
        for (final featureData in featuresData) {
          final feature = RoomFeaturesModel.fromJson(featureData);
          features.add(feature);
        }
        return features;
      }

      if (statusCode == 400) {
        if (data['message'] != "Room does not belong to this Daklia") {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          Dialogs.errorDialog(Get.context!, 'room_not_belong_to_daklia'.tr);
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
        if (data['message'] != 'Room does not exist') {
          timer = Timer(const Duration(seconds: 1), () {
            EasyLoading.dismiss();
          });
          Dialogs.errorDialog(Get.context!, 'room_does_not_exist'.tr);
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
      return [];
    });
  }

  Future<RoomFeaturesModel> addFeature({
    required int roomId,
    required String featureName,
    required String featureDescription,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final response = await post(
        '${HttpHelper.baseUrl2}/${storage.read('dakliaId')}${HttpHelper.rooms}${HttpHelper.addFeatures}',
        {
          'room_id': roomId,
          'feature_name': featureName,
          'feature_description': featureDescription,
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
    var roomController = RoomManagementController();

    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('featureId', data['feature_id']);
      Dialogs.successDialog(Get.context!, 'feature_added_successfully'.tr);
      roomFeatures(Get.context!);
      // // make disponse to the controller
      // roomController.featureController.clear();
      // roomController.otherDetailsController.clear();
      roomController.getRoomFeatures();
      return RoomFeaturesModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] != "Room does not belong to this Daklia") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'room_not_belong_to_daklia'.tr);
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
      if (data['message'] != 'Room does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'room_does_not_exist'.tr);
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
    return RoomFeaturesModel.fromJson(data);
  }
}
