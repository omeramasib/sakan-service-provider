import 'package:get/get.dart';

class AuthController extends GetxController {

  RxBool selectValue = false.obs;
  set selectLoginOrRegister(bool value) {
    selectValue.value = value;
    update();
  }

  bool get selectLoginOrRegister => selectValue.value;

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


}
