import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/location_constants.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:location/location.dart';

/// Determine the current position of the device.

Future<LocationData?> getUserLocationData() async {
  Location location = locator<Location>();
  bool serviceEnabled;
  PermissionStatus permissionStatus;

  // Test if location services are enabled.
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    // return Future.error('Location services are disabled.');
    serviceEnabled = await location.requestService();
    debugPrint("Location services are disabled.");
    if (!serviceEnabled) {
      return LocationConstants.userLocationFromIP?.toLocationData();
    }
  }

  permissionStatus = await await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      // return Future.error('Location permissions are denied');
      debugPrint("Location permissions are denied");
      return LocationConstants.userLocationFromIP?.toLocationData();
    }
  }

  if (permissionStatus == PermissionStatus.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    // return Future.error(
    //     'Location permissions are permanently denied, we cannot request permissions.');
    debugPrint(
        "Location permissions are permanently denied, we cannot request permissions.");
    return LocationConstants.userLocationFromIP?.toLocationData();
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  debugPrint("Location permissions are granted");

  return await location.getLocation();
}
