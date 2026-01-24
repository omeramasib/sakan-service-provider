import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/network_controller.dart';

class NetworkView extends GetView<NetworkController> {
  const NetworkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetworkView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'NetworkView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
