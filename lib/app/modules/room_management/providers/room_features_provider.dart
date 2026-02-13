import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/room_features_model.dart';
import 'package:http/http.dart' as http;

class RoomFeaturesProvider extends GetConnect {
  static RoomFeaturesProvider get instance => Get.put(RoomFeaturesProvider());
  final SecureStorageService storage = SecureStorageService.instance;
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

  // make method to get all features (uses http.get for safe parsing when server returns HTML)
  Future<List<RoomFeaturesModel>> getAllFeatures({
    required String roomId,
  }) async {
    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final url = Uri.parse(
      '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}$roomId/features/',
    );
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    var statusCode = response.statusCode;
    final body = response.body;
    log('this is the status code: $statusCode');

    // Only parse as JSON when response looks like JSON (server may return HTML for errors)
    List<dynamic>? featuresData;
    Map<String, dynamic>? dataMap;
    if (body.trim().isNotEmpty && !body.trim().toLowerCase().startsWith('<')) {
      try {
        final decoded = json.decode(body);
        if (decoded is List) {
          featuresData = decoded;
        } else if (decoded is Map<String, dynamic>) {
          dataMap = decoded;
        }
      } catch (_) {
        log('Get all features response is not valid JSON (e.g. HTML error page)');
      }
    }
    if (featuresData != null) {
      log('this is the data: $featuresData');
    }

    if (statusCode == 200 && featuresData != null) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      final List<RoomFeaturesModel> features = [];
      for (final featureData in featuresData) {
        try {
          features.add(RoomFeaturesModel.fromJson(featureData));
        } catch (_) {
          // skip invalid item
        }
      }
      return features;
    }

    if (statusCode == 400) {
      if (dataMap != null && dataMap['message'] != "Room does not belong to this Daklia") {
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
      final message = dataMap?['message']?.toString() ?? '';
      if (message.contains('Room') && message.contains('not exist')) {
        Dialogs.errorDialog(Get.context!, 'room_does_not_exist'.tr);
      } else {
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

    if (featuresData == null && dataMap == null && statusCode != 200) {
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
    return [];
  }

  Future<RoomFeaturesModel> addFeature({
    required int roomId,
    required String featureName,
    required String featureDescription,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final response = await post(
        '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}${HttpHelper.addFeatures}',
        {
          'room_id': roomId,
          'feature_name': featureName,
          'feature_description': featureDescription,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        });

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('featureId', data['feature_id']?.toString());
      Dialogs.successDialog(Get.context!, 'feature_added_successfully'.tr);
      Get.offAllNamed(Routes.ROOM_MANAGEMENT);
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

  Future<RoomFeaturesModel> editFeature({
    required int roomId,
    required String featureName,
    required String featureDescription,
    required int featureId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final response = await put(
        '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}$roomId/features/$featureId/',
        {
          'feature_name': featureName,
          'feature_description': featureDescription,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        });

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, 'feature_updated_successfully'.tr);
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

  Future<void> deleteFeature({
    required int roomId,
    required int featureId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    final response = await delete(
        '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}$roomId/features/$featureId/delete/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        });

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      Dialogs.successDialog(Get.context!, 'feature_deleted_successfully'.tr);
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
  }
}
