import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocation {
  // Future<dynamic> position(BuildContext context) async {
  //   if (kDebugMode) {
  //     print("method is running===");
  //   }
  //   bool service;
  //
  //   service = await Geolocator.isLocationServiceEnabled();
  //   print("service == $service");
  //   if (!service) {
  //     print("location service is not available");
  //     return ScaffoldMessenger.of(context).showMaterialBanner(
  //       MaterialBanner(
  //         leading: const Icon(Icons.location_disabled_outlined),
  //         content: const Text(
  //             "Location service is not enabled!\nEnable it from settings."),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               await Geolocator.openLocationSettings();
  //             },
  //             child: const Text("Enable"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  //             },
  //             child: const Text("Dismiss"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Location permissions are denied"),
  //           // TODO: give option to move to location settings
  //           // needs to add another package for this function
  //         ),
  //       );
  //     }
  //     return ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Permission is permanently denied"),
  //       ),
  //     );
  //   }
  //   Position location = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   if (kDebugMode) {
  //     print("this current location is === ${location}");
  //   }
  //   print('saving to prefs');
  //
  //   return location;
  // }

  Future<dynamic> getCoordinates(BuildContext context) async {
    LocationPermission permissions;
    Position currentPosition;

   try {
      await Geolocator.requestPermission();

      permissions = await Geolocator.checkPermission();
      if (permissions == LocationPermission.denied) {
        permissions = await Geolocator.requestPermission();
        if (permissions == LocationPermission.denied) {
          return;
        }
      }

      if (permissions == LocationPermission.deniedForever) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                "Permission is permanently denied, Enable from settings"),
            action: SnackBarAction(
                label: "Enable",
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                }),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // if (permissions == LocationPermission.always || permissions == LocationPermission.) {
      currentPosition = await Geolocator.getCurrentPosition();
      var latitude = currentPosition.latitude.toString();
      var longitude = currentPosition.longitude.toString();
      // }
      print("the coordinates are $latitude and $longitude");
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      // saving coordinates
      await prefs.setString("lat", latitude);
      await prefs.setString("lon", longitude);
      print("prefs saved");
      print("type: ${latitude.runtimeType}");
      print("get pref data : ${await prefs.getString("lat")}");
      return;
    } catch (e){
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text("Error occured: ${e.toString()}"),
         action: SnackBarAction(
             label: "➡️",
             onPressed: () async {
               await Geolocator.openLocationSettings();
             }),
         behavior: SnackBarBehavior.floating,
         duration: const Duration(seconds: 3),
       ),
     );
   }
  }
}

/* types of parameters
  required params = fun(int a, int b)
  optional params = fun(int a, int b, [String c = ""]) // place optional at the last
  named params = fun(int a, int b, {String c = ""}) // name the var while calling the function
 */
