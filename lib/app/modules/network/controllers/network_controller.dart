import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../../../constants/dialogs.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.put(NetworkController());
  var connectionStatus = 0.obs;
  RxBool isConnected = false.obs;

  static NetworkController get to => Get.find();

  final connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? subscription;
  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  Future<void> initConnectivity() async {
    var result;
    try {
      result = await (connectivity.checkConnectivity());
    } on Exception catch (e) {
      print(e.toString());
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        isConnected.value = true;
        log('this is the connection wifi status: ${connectionStatus.value}');
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        isConnected.value = true;
        log('this is the connection mobile status: ${connectionStatus.value}');
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        isConnected.value = false;
        log('this is the connection none status: ${connectionStatus.value}');
        break;
      default:
        Dialogs.connectionErrorDialog(Get.context!);
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    subscription!.cancel();
  }
}
