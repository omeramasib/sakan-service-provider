import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../model/regulations_model.dart';
import '../provider/regulations_provider.dart';

class RegulationsManagementController extends GetxController {
  var regulationTextController = TextEditingController();
  var regulationDescriptionController = TextEditingController();
  var editRegulationTextController = TextEditingController();
  var editRegulationDescriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  static RegulationsManagementController get instance =>
      Get.put(RegulationsManagementController());

  final provider = DakliaRegulationsProvider();
  final storage = SecureStorageService.instance;
  final lawsList = <DakliaLawsModel>[].obs;
  final isLoading = false.obs;

  DakliaLawsModel myLaws = DakliaLawsModel();

  set setLaws(DakliaLawsModel lawModel) {
    myLaws = lawModel;
    update();
  }

  DakliaLawsModel get getLaws => myLaws;

  DakliaLawsModel myServiceFeatures = DakliaLawsModel();

  Future<void> getLawsList() async {
    isLoading.value = true;
    try {
      final dakliaId = (await storage.read('dakliaId')).toString();
      final data = await provider.getLawsList(dakliaId);
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
          punishmentDescription: regulationDescriptionController.text);
      Get.back();
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

  Future<void> editLaw() async {
    try {
      await provider.editLaw(
        lawId: myLaws.lawId!,
        lawDescription: editRegulationTextController.text == ''
            ? myLaws.lawDescription!
            : editRegulationTextController.text,
        punishmentDescription: editRegulationDescriptionController.text == ''
            ? myLaws.punishmentDescription!
            : editRegulationDescriptionController.text,
      );
      EasyLoading.show(status: 'loading'.tr);
      getLawsList();
      Get.back();
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_edit_law'.tr);
    }
    update();
  }

  Future deleteLaw() async {
    EasyLoading.show(status: 'loading'.tr);
    try {
      final dakliaId = (await storage.read('dakliaId')).toString();
      await provider.deleteLaw(dakliaId, myLaws.lawId!.toString());
      getLawsList();
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_delete_law'.tr);
    }
    update();
  }

  @override
  void onInit() {
    regulationTextController = TextEditingController();
    regulationDescriptionController = TextEditingController();
    editRegulationTextController = TextEditingController();
    editRegulationDescriptionController = TextEditingController();
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
