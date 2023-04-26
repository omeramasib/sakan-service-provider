import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_single_room_controller.dart';

class EditSingleRoomView extends GetView<EditSingleRoomController> {
  const EditSingleRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditSingleRoomView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditSingleRoomView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
