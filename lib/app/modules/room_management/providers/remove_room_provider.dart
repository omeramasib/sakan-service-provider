import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/response/theResponse.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';
import '../models/daklia_rooms_models.dart';
import 'package:http/http.dart' as http;

class RemoveRoomProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static RemoveRoomProvider get instance => Get.put(RemoveRoomProvider());
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

  deleteRoom(String dakliaId, String roomId) async {
    final url = Uri.parse(
      '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}$roomId/${HttpHelper.deleteRoom}',
    );

    final token = await storage.read('token');
    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    print('this is the response: ${response.body}');
    print('this is the status code: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Handle successful deletion
      if (response.statusCode == 204) {
        // Status 204 means success with no content - don't try to parse JSON
        log('Room deleted successfully - no content returned (204)');
        Dialogs.successDialog(Get.context!, 'delete_room_successufully'.tr);
        Get.offAllNamed(Routes.ROOM_MANAGEMENT);
        return null; // No data to return for 204
      } else {
        // Status 200 means success with content - parse JSON only if body looks like JSON
        final body = response.body;
        if (body.trim().isEmpty || body.trim().toLowerCase().startsWith('<')) {
          log('Delete room response is HTML or empty');
          Dialogs.successDialog(Get.context!, 'delete_room_successufully'.tr);
          Get.offAllNamed(Routes.ROOM_MANAGEMENT);
          return null;
        }
        try {
          final roomsData = json.decode(body);
          log('this is the rooms data: $roomsData');
          Dialogs.successDialog(Get.context!, 'delete_room_successufully'.tr);
          Get.offAllNamed(Routes.ROOM_MANAGEMENT);
          return roomsData;
        } catch (e) {
          log('Failed to parse delete response: $e');
          Dialogs.successDialog(Get.context!, 'delete_room_successufully'.tr);
          Get.offAllNamed(Routes.ROOM_MANAGEMENT);
          return null;
        }
      }
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
      Dialogs.errorDialog(Get.context!, 'room_not_exist'.tr);
    }
    if (response.statusCode == 400) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'invalid_data'.tr);
    }
  }
}
