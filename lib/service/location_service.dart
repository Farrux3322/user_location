import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:user_location/providers/address_call_provider.dart';

initLocationService(BuildContext context ) async {
  Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();

  debugPrint("LONGITUDE:${locationData.longitude} AND LAT:${locationData.longitude}");

  location.enableBackgroundMode(enable: true);

  location.onLocationChanged.listen((LocationData newLocation) {
    context.read<AddressCallProvider>().addStreamMarker(newLocation);
    debugPrint("LONGITUDE:${newLocation.longitude}");
  });
}
