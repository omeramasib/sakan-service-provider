import 'package:get/get.dart';

class MyAppointmentsController extends GetxController {

  final count = 0.obs;

  RxInt tabIndex = 0.obs;
  RxInt tabIndex2 = 0.obs;
  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }

  RxInt selectIndex = 0.obs;
  RxInt selectIndex2 = 0.obs;
  void changeSelectIndex(int i) {
    selectIndex.value = i;
    update();
  }

  void changeTabIndex2(int index) {
    tabIndex2.value = index;
    update();
  }

  void changeSelectIndex2(int i) {
    selectIndex2.value = i;
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
