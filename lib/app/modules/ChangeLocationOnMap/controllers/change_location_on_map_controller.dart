import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../network/controllers/network_controller.dart';
import '../model/change_location_model.dart';
import '../provider/change_location_provider.dart';

class ChangeLocationOnMapController extends GetxController {
  late Future getCurrentLocationFuture;
  LatLng? currentPosition;
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> gMC = Completer();
  var initZoom = 14.4746;

  // update camera position
  void onCameraMove(CameraPosition position) {
    log(position.toString(), name: "########################");
    update();
  }

  Completer<GoogleMapController> get getController => gMC;

  // get on camera move
  void Function(CameraPosition) get getOnCameraMove => onCameraMove;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  TextEditingController addressDetailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  RxDouble lat = 0.0.obs;
  double get getLat => lat.value;
  RxDouble lon = 0.0.obs;
  double get getLon => lon.value;
  String address = '';
  String additionalAddress = '';
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

    update();

    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
    var position = await getCurrentLocation();
    try {
      position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );
    } catch (e) {
      position = null as Position;
      debugPrint(e.toString());
    }

    if (position != null) {
      lat.value = position.latitude;
      lon.value = position.longitude;
      LatLng location = LatLng(position.latitude, position.longitude);
      log('this is the lon and lat: ${lat.value} , ${lon.value}');
      currentPosition = location;
    }

    markers.add(
      Marker(
        markerId: MarkerId('currentPosition'),
        position: LatLng(lat.value, lon.value),
        infoWindow: InfoWindow(
          title: 'Your Location',
        ),
      ),
    );

    getAddresFromLatLon(position);

    update();

    return true;
  }

  Future<void> getAddresFromLatLon(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      address =
          "${place.country} , ${place.locality}, ${place.name}, ${place.street}";
    } catch (e) {
      print(e);
    }
  }

  var addressProvider = ChangeLocationProvider();

  var networkController = NetworkController();

  Future<ChangeLocationModel> changeAdress() async {
    return await addressProvider
        .changeAddress(
      longitude: lon.value.toString(),
      latitude: lat.value.toString(),
      address: address,
      additonal_address: additionalAddress,
    )
        .timeout(
      Duration(seconds: 3),
      onTimeout: () {
        EasyLoading.dismiss();
        return ChangeLocationModel();
      },
    );
  }

  void checkChangeAddress() async{
    var isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   login();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    await changeAdress();
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getCurrentLocationFuture = _getCurrentLocation();
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
