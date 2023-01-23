import 'dart:async';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CompleteDakliaAccount2Controller extends GetxController {
  //TODO: Implement CompleteDakliaAccount2Controller

  final count = 0.obs;
  RxDouble lat = 0.0.obs ;
  RxDouble lon = 0.0.obs ;
  var address = ''.obs ;
  late StreamSubscription<Position> streamSubscription;


  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

     permission = await Geolocator.checkPermission();

     if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }

    streamSubscription = Geolocator.getPositionStream().listen((Position position) {
      // print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      lat.value = position.latitude;
      lon.value = position.longitude;
      log('this is the lon and lat: ${lat.value} , ${lon.value}');
      getAddresFromLatLon(position);
    });

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddresFromLatLon(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      address.value = "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }
  @override
  void onInit() async{
    super.onInit();
    await getCurrentLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    streamSubscription.cancel();
  }

  void increment() => count.value++;
}
