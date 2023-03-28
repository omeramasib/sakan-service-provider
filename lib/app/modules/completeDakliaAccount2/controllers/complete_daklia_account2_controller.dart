import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../network/controllers/network_controller.dart';
import '../model/daklia_location_model.dart';
import '../providers/daklia_location_provider.dart';

class CompleteDakliaAccount2Controller extends GetxController {
  late Future getCurrentLocationFuture;
  LatLng? currentPosition;
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
//kGooglePlex
  Completer<GoogleMapController> _controller = Completer();

  //Get CameraPosition
  // CameraPosition kGooglePlex = CameraPosition(
  //   target: LatLng(lat.value, lon.value),
  //   zoom: 14.4746,
  // );

  // update camera position
  void onCameraMove(CameraPosition position) {
    log(position.toString(), name: "########################");
    // kGooglePlex = position;
    // animateCamera();
    update();
  }

  // animate camera
  // Future<void> animateCamera() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  // }

  // void onMapCreated(GoogleMapController controller) {
  //   log(controller.toString(), name: "########################");
  //   _controller.complete(controller);
  //   update();
  // }

  // get camera position
  // CameraPosition get getCameraPosition => kGooglePlex;

  // get controller
  Completer<GoogleMapController> get getController => _controller;

  // get on camera move
  void Function(CameraPosition) get getOnCameraMove => onCameraMove;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() async {
    super.onInit();
    getCurrentLocationFuture = _getCurrentLocation();
    // getCurrentLocation();
    // getCurrentLocationFuture = getCurrentLocation();
    // Geolocator.getPositionStream().listen(
    //   (Position position) async {
    //     log(position.toString(), name: "########################");

    //     // print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    //     lat.value = position.latitude;
    //     lon.value = position.longitude;
    //     log('this is the lon and lat: ${lat.value} , ${lon.value}');
    //     getAddresFromLatLon(position);
    //   },
    // );
    // await getCurrentLocation();
  }

  TextEditingController addressDetailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  RxDouble lat = 0.0.obs;
  double get getLat => lat.value;
  RxDouble lon = 0.0.obs;
  double get getLon => lon.value;
  String address = '';
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

    

    // streamSubscription = Geolocator.getPositionStream().listen(
    //   (Position position) {
    //     log(position.toString(), name: "########################");

    //     lat.value = position.latitude;
    //     lon.value = position.longitude;
    //     log('this is the lon and lat: ${lat.value} , ${lon.value}');
    //     getAddresFromLatLon(position);
    //   },
    // );

    // Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT2);
    update();

    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true,
          timeLimit: Duration(seconds: 15));
    } catch (e) {
      position = null as Position;
      debugPrint(e as String?);
    }

    if (position != null) {
      lat.value = position.latitude;
      lon.value = position.longitude;
      LatLng location = LatLng(position.latitude, position.longitude);
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

    update();

    return true;
  }

  Future<void> getAddresFromLatLon(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      address = "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  var addressProvider = DakliaLocationProvider();

  var networkController = NetworkController();

  Future<DakliaLocationModel> sendAdress() async {
    return await addressProvider
        .sendAddress(
      longitude: lon.value.toString(),
      latitude: lat.value.toString(),
      additonal_address: address,
    )
        .timeout(
      Duration(seconds: 2),
      onTimeout: () {
        EasyLoading.dismiss();
        return DakliaLocationModel();
      },
    );
  }

  void checkSendAddress() {
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
    sendAdress();
    update();
  }

  // Future<DakliaLocationModel> sendAdress()

  // void _currentLocation() async {
  //  final GoogleMapController controller = await _controller.future;
  //  LocationData currentLocation;
  //  var location = new Location();
  //  try {
  //    currentLocation = await location.getLocation();
  //    } on Exception {
  //      currentLocation = null;
  //      }

  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       bearing: 0,
  //       target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       zoom: 17.0,
  //     ),
  //   ));
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
