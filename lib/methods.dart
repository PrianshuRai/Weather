import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<dynamic> position(BuildContext context) async {
  if (kDebugMode) {
    print("method is running===");
  }
  bool service;

  service = await Geolocator.isLocationServiceEnabled();
  print("service == $service");
  if (!service) {
    return ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.location_disabled_outlined),
        content: const Text("Location service is not enabled!"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Enable"),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text("Dismiss"),
          ),
        ],
      ),
    );
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permissions are denied"),
          // TODO: give option to move to location settings
          // needs to add another package for this function
        ),
      );
    }
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Permission is permanently denied"),
      ),
    );
  }
  Position location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  if (kDebugMode) {
    print("this current location is === $location");
  }
}



/* types of parameters
  required params = fun(int a, int b)
  optional params = fun(int a, int b, [String c = ""]) // place optional at the last
  named params = fun(int a, int b, {String c = ""}) // name the var while calling the function
 */



