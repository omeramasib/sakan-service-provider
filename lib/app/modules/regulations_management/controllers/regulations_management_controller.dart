import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../model/regulations_model.dart';
import '../provider/regulations_provider.dart';

class RegulationsManagementController extends GetxController {
  var regulationTextController = TextEditingController();
  var regulationDescriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  static RegulationsManagementController get instance =>
      Get.put(RegulationsManagementController());

  final provider = DakliaRegulationsProvider();
  final storage = GetStorage();
  final lawsList = <DakliaLawsModel>[].obs;
  final isLoading = false.obs;

  DakliaLawsModel myLaws = new DakliaLawsModel();

  set setLaws(DakliaLawsModel lawModel) {
    myLaws = lawModel;
    update();
  }

  DakliaLawsModel get getLaws => myLaws;

  DakliaLawsModel myServiceFeatures = new DakliaLawsModel();

  Future<void> getLawsList() async {
    isLoading.value = true;
    try {
      final data =
          await provider.getLawsList(storage.read('dakliaId').toString());
      lawsList.clear();
      lawsList.addAll(data);
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_load_laws'.tr);
    }
    EasyLoading.dismiss();
    isLoading.value = false;
    update();
  }

    Future<void> addLaw() async {
    try {
      await provider.addLaw(
        lawDescription: regulationTextController.text,
        punishmentDescription: regulationDescriptionController.text
      );
      getLawsList();
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_law'.tr);
    }
    EasyLoading.dismiss();
    update();
  }

  void checkAddLaw() {
    var isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    formKey.currentState!.save();
    EasyLoading.show(status: 'loading'.tr);
    addLaw();
    update();
  }

  @override
  void onInit() {
    regulationTextController = TextEditingController();
    regulationDescriptionController = TextEditingController();
    getLawsList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // regulationTextController.dispose();
    // regulationDescriptionController.dispose();
  }
}
