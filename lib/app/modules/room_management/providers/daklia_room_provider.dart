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
import '../models/daklia_rooms_models.dart';
import 'package:http/http.dart' as http;

class DakliaRoomProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static DakliaRoomProvider get instance => Get.put(DakliaRoomProvider());
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

  Future<List<DakliaRoomModel>> getRoomsList(String dakliaId) async {
    final url = Uri.parse(
      '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${storage.read('token')}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> roomsData = json.decode(response.body);
      log('this is the rooms data: $roomsData');
      final List<DakliaRoomModel> rooms = [];

      roomsData.forEach((roomData) {
        final room = DakliaRoomModel.fromJson(roomData);
        rooms.add(room);
      });

      return rooms;
    }
    if (response.statusCode == 401) {
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

    if (response.statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
    }
    if (response.statusCode == 400) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'invalid_data'.tr);
    }
    return [];
  }

  // Future<List<DakliaRoomModel>> getRoomsList(String? id) async {
  //   final response = await get(
  //     '${HttpHelper.baseUrl2}/$id${HttpHelper.rooms}',
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Token ${storage.read('token')}',
  //     },
  //   );

  //   if (response.response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     List<DakliaRoomModel> rooms = data.map((room) => DakliaRoomModel.fromJson(room)).toList();
  //     return rooms;
  //   } else {
  //     throw Exception('Failed to load rooms');
  //   }
  // }
}

  // Handle other status codes
  // ...





  // Future getRoomsList(String? id) async {
  //   final response = await get(
  //     '${HttpHelper.baseUrl2}/$id${HttpHelper.rooms}',
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Token ${storage.read('token')}',
  //     },
  //   );

  //   var data = response.body;
  //   var statusCode = response.statusCode;
  //   log('this is the request url: ${response.request?.url}');
  //   log('this is the status code: $statusCode');
  //   log(data.toString());

  //   if (statusCode == 200) {
  //     timer = Timer(const Duration(seconds: 1), () {
  //       EasyLoading.dismiss();
  //     });

  //     return DakliaRoomModel.fromJson(json.decode(data));
  //   }

  //   if (statusCode == 401) {
  //     timer = Timer(const Duration(seconds: 1), () {
  //       EasyLoading.dismiss();
  //     });
  //     Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
  //     Get.offAllNamed(Routes.AUTH, arguments: 0);
  //   }
  //   if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
  //     timer = Timer(const Duration(seconds: 1), () {
  //       EasyLoading.dismiss();
  //     });
  //     Dialogs.errorDialog(Get.context!, 'server_error'.tr);
  //   }

  //   if (statusCode == 404) {
  //     timer = Timer(const Duration(seconds: 1), () {
  //       EasyLoading.dismiss();
  //     });
  //     Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
  //   }
  // }

