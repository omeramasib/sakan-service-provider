import 'package:get/get.dart';

import '../../room_management/controllers/room_management_controller.dart';
import '../../room_management/models/room_features_model.dart';

class EditRoomFeatureController extends GetxController {

  var roomController = Get.put(RoomManagementController());

  RoomFeaturesModel myRoomFeatures = new RoomFeaturesModel();

  set setRoomFeatures(RoomFeaturesModel features) {
    myRoomFeatures = features;
    update();
  }

  RoomFeaturesModel get getFeatures => myRoomFeatures;

  @override
  void onInit() {
    super.onInit();
    // roomController.getRoomFeatures();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
