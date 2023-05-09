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
  var editServiceNameController = TextEditingController();
  var editServicePriceController = TextEditingController();
  var editServiceDescriptionController = TextEditingController();
  String servicePrice = '0';
  String editServicePrice = '0';
  var formKey = GlobalKey<FormState>();
  RxBool isAvailable = true.obs;
  RxBool editIsAvailable = false.obs;
  RxString serviceType = 'free'.obs;
  RxString editServiceType = 'free'.obs;

  chooseIsAvailable(bool value) {
    isAvailable.value = value;
    update();
  }

  chooseEditIsAvailable(bool value) {
    editIsAvailable.value = value;
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

  chooseEditServiceType(String value) {
    if (value == '') {
      editServiceType.value = 'free';
      log('$serviceType');
    } else {
      editServiceType.value = 'paid';
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

  Future<void> getServiceList() async {
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
      getServiceList();
      Dialogs.successDialog(Get.context!, 'service_added_successfully'.tr);
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

  Future<void> editService() async {
    final serviceId = myServices.serviceId;
    try {
      await provider.editService(
        serviceId: serviceId!,
        serviceName: editServiceNameController.text == ''
            ? editServiceNameController.text = myServices.serviceName!
            : editServiceNameController.text,
        serviceDescription: editServiceDescriptionController.text == ''
            ? editServiceDescriptionController.text =
                myServices.serviceDescription!
            : editServiceDescriptionController.text,
        servicePrice: editServicePrice == ''
            ? editServicePrice = myServices.servicePrice!.toString()
            : editServicePrice,
        serviceType: editServiceType.value,
        isAvailable: isAvailable.value,
      );
      getServiceList();
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_edit_service'.tr);
    }
    EasyLoading.dismiss();
    update();
  }

  checkSendUpdate() {
    // var isValid = formKey.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }

    // formKey.currentState!.save();
    EasyLoading.show(status: 'loading'.tr);
    editService();
    update();
  }

  Future<void> removeRoom() async {
    try {
      final serviceId = myServices.serviceId;
      final data = await provider.deleteService(
          storage.read('dakliaId').toString(), serviceId.toString());
      print('this is the data: $data');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_remove_service'.tr);
    }
    isLoading.value = false;
    EasyLoading.show(status: 'loading'.tr);
    update();
  }

  Future<void> refresServiceList() async {
    await getServiceList();
    update();
  }

  @override
  void onInit() {
    serviceNameController = TextEditingController();
    servicePriceController = TextEditingController();
    serviceDescriptionController = TextEditingController();
    editServiceNameController = TextEditingController();
    editServicePriceController = TextEditingController();
    editServiceDescriptionController = TextEditingController();

    getServiceList();
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
