import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:js/js.dart';
import 'package:weather/main.dart';

import 'locationJS.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  TextEditingController searchField = TextEditingController();
  var _latitude;
  var _longitude;
  bool menuOpen = false;

  Future getLoc() async {
    var req = await http.get(Uri.parse('https://geolocation-db.com/json/'));
    Map<String, dynamic> data = jsonDecode(req.body);
    print("data = $data");
  }

  success(pos) async {
    try {
      // mypos = [pos.coords.latitude, pos.coords.longitude];
      _latitude = pos.coords.latitude;
      _longitude = pos.coords.longitude;
    } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
    setState(() {
      query['lat'] = _latitude;
      query['lon'] = _longitude;
    });
    var data = callApi();
    print("your data is here: $data");
  }

  Future<void> loc() async {
    if (kIsWeb) {
      getCurrentPosition(allowInterop((pos) => success(pos)));
    }
  }

  @override
  Widget build(BuildContext context) {
    loc();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 65,
            width: MediaQuery.of(context).size.width * .85,
            color: Colors.transparent,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black26.withOpacity(0.5),
                        Colors.black26.withOpacity(0.5)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      menuOpen == false
                          ? IconButton(
                              icon: const Icon(Icons.menu),
                              color: Colors.white70,
                              iconSize: 30,
                              tooltip: "Open settings",
                              onPressed: () {
                                setState(() {
                                  menuOpen = true;
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.close_rounded),
                              color: Colors.white70,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  menuOpen = false;
                                });
                              },
                            ),
                      Expanded(
                        child: TextFormField(
                          controller: searchField,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          autocorrect: true,
                          style: GoogleFonts.getFont('Lato',
                              textStyle: Theme.of(context).textTheme.headline6,
                              // fontSize: 18,
                              color: Colors.white70),
                          decoration: const InputDecoration(
                              hintText: "New Delhi, India",
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 30,
                        ),
                        tooltip: "search",
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        onPressed: () {
                          place = searchField.text;
                          callApi();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            text: "22",
            style: GoogleFonts.getFont('Lato',
                textStyle: Theme.of(context).textTheme.headline1,
                color: Colors.white.withOpacity(.7),
                fontWeight: FontWeight.w800),
            children: [
              TextSpan(
                text: '\u00B0',
                style: GoogleFonts.getFont('Lato',
                    textStyle: Theme.of(context).textTheme.headline1,
                    color: Colors.white.withOpacity(.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4
                    // fontSize: 30,
                    ),
              ),
              query["units"] == 'metric'
                  ? TextSpan(
                      text: 'C',
                      style: GoogleFonts.getFont(
                        'Lato',
                        textStyle: Theme.of(context).textTheme.headline1,
                        color: Colors.white.withOpacity(.7),
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : query["units"] == "imperial"
                      ? TextSpan(
                          text: "F",
                          style: GoogleFonts.getFont(
                            'Lato',
                            textStyle: Theme.of(context).textTheme.headline1,
                            color: Colors.white.withOpacity(.7),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TextSpan(
                          text: "K",
                          style: GoogleFonts.getFont(
                            'Lato',
                            textStyle: Theme.of(context).textTheme.headline1,
                            color: Colors.white.withOpacity(.7),
                            fontWeight: FontWeight.w400,
                          ),
                        )
            ],
          ),
        ),
      ],
    );
  }
}

// _getCurrentLocation() {
//   if (kIsWeb) {
//     getCurrentPosition(allowInterop((pos) => success(pos)));
//   }
// }

// Future<Object?> _getLocation() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//   await Permission.location.request();
//
//   if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
//     try {
//       Position currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       if (kDebugMode) {
//         print("current location: $currentPosition");
//       }
//       return currentPosition;
//     } on Exception {
//       Position? lastPosition = await Geolocator.getLastKnownPosition();
//       print('last position: $lastPosition');
//       return lastPosition;
//     }
//   }
//
//   // check for the location
//   permission = await Geolocator.checkPermission();
//   // // if the permission is denied by the user
//   // // earlier, then ask for the permission again
//   // if (permission == LocationPermission.denied) {
//   //   // show dialog for location permission
//   //   permission = await Geolocator.requestPermission();
//   //   // if location permission is denied again intentionally
//   //   // maybe user doesn't want to use the app.
//   //   if (permission == LocationPermission.denied) {
//   //     return Future.error('Location permissions are denied');
//   //   }
//   // }
//   // if (permission == LocationPermission.deniedForever) {
//   //   // Permissions are denied forever, handle appropriately.
//   //   // the user is a rude person
//   //   return Future.error(
//   //       'Location permissions are permanently denied, we cannot request permissions.');
//   // }
// }
// }
