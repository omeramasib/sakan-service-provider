import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_room_feature_controller.dart';

class EditRoomFeatureView extends GetView<EditRoomFeatureController> {
  const EditRoomFeatureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditRoomFeatureView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EditRoomFeatureView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
