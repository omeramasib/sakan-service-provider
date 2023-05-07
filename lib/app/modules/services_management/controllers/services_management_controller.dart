import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../model/service_model.dart';
import '../providers/service_provider.dart';

class ServicesManagementController extends GetxController {
  var serviceNameController = TextEditingController();
  var servicePriceController = TextEditingController();
  var serviceDescriptionController = TextEditingController();
  String servicePrice = '0';
  var formKey = GlobalKey<FormState>();
  RxBool isAvailable = false.obs;
  RxString serviceType = 'free'.obs;
  chooseIsAvailable(bool value) {
    isAvailable.value = value;
    update();
  }

  chooseServiceType(String value) {
    if (value == '') {
      serviceType.value = 'free';
      log('$serviceType');
    } else {
      serviceType.value = 'paid';
      log('$serviceType');
    }
    update();
  }

  static ServicesManagementController get instance =>
      Get.put(ServicesManagementController());

  final provider = DakliaServiceProvider();
  final storage = GetStorage();
  final servicesList = <ServiceModel>[].obs;
  final isLoading = false.obs;

  ServiceModel myServices = new ServiceModel();

  set setServices(ServiceModel serviceModel) {
    myServices = serviceModel;
    update();
  }

  ServiceModel get getServices => myServices;

  ServiceModel myServiceFeatures = new ServiceModel();

  Future<void> getRoomsList() async {
    isLoading.value = true;
    final dakliaId = storage.read('dakliaId').toString();
    try {
      final data = await provider.getServiceList(dakliaId);
      servicesList.clear();
      servicesList.addAll(data);
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_load_services'.tr);
    }
    EasyLoading.dismiss();
    isLoading.value = false;
    update();
  }

  Future<void> addService() async {
    final dakliaId = storage.read('dakliaId').toString();
    try {
      await provider.addService(
        serviceId: dakliaId,
        serviceName: serviceNameController.text,
        serviceDescription: serviceDescriptionController.text,
        servicePrice: servicePrice,
        serviceType: serviceType.value,
        isAvailable: isAvailable.value,
      );
      getRoomsList();
      Dialogs.successDialog(Get.context!, 'Service_added_successfully'.tr);
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_service'.tr);
    }
    EasyLoading.dismiss();
    update();
  }

  void checkAddService() {
    var isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    formKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   try {
    //     updatePatientProfile();
    //   } catch (e) {
    //     EasyLoading.dismiss();
    //     print(e);
    //   }
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    addService();
    update();
  }

  @override
  void onInit() {
    serviceNameController = TextEditingController();
    servicePriceController = TextEditingController();
    getRoomsList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    serviceNameController.dispose();
    servicePriceController.dispose();
    serviceDescriptionController.dispose();
    super.onClose();
  }
}
