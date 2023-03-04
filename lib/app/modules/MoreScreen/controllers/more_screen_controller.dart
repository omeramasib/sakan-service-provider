import 'package:get/get.dart';

class MoreScreenController extends GetxController {
  //TODO: Implement MoreScreenController

  final count = 0.obs;

  RxBool toogleStatus = false.obs;
  void changeToogleStatus(bool value) {
    toogleStatus.value = value;
    update();
  }
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
