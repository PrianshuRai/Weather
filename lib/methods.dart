import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocation {

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
