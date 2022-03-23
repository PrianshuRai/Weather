import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/main.dart';
import 'package:weather/methods.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  TextEditingController searchField = TextEditingController();
  bool menuOpen = false;
  bool _celcius = false;

  // settings bottom sheet
  Future<dynamic> showImageSource(BuildContext context) async {
    if (menuOpen) {
      return showModalBottomSheet(
          barrierColor: Colors.black26.withOpacity(.3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          context: context,
          builder: (context) {
            return Container(
              height: 250.0,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: <Color>[
                            const Color(0xFF263238).withOpacity(0.6), //BBDEFB
                            const Color(0xFF263238).withOpacity(0.6) // FFCDD2
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Settings',
                                  style: GoogleFonts.getFont(
                                    "Lato",
                                    color: Colors.white70,
                                    textStyle:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                const Icon(
                                  Icons.settings_rounded,
                                  color: Colors.white70,
                                  size: 26,
                                )
                              ],
                            ),
                            SwitchListTile(
                              title: Text(
                                'Metrics',
                                style: GoogleFonts.getFont(
                                  "Lato",
                                  color: Colors.white70,
                                  fontSize: 24,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              secondary: const Icon(
                                Icons.thermostat_rounded,
                                color: Colors.white60,
                                size: 26,
                              ),
                              subtitle: Text(
                                'Switch on for values in Fahrenheit',
                                style: GoogleFonts.getFont(
                                  "Lato",
                                  color: Colors.white54,
                                  fontSize: 12,
                                  textStyle:
                                      Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              value: _celcius,
                              onChanged: (bool value) {
                                if (kDebugMode) {
                                  print("switch value is $value");
                                }
                                setState(() {
                                  _celcius = value;
                                  print(value);
                                });
                                if (_celcius = false) {
                                  query['units'] = 'Imperial';
                                  print('unit value changed == $query');
                                } else if (_celcius = true) {
                                  query['units'] = 'metric';
                                  print('unit value changed == $query');
                                }
                              },
                            )
                          ],
                        ),
                      )),
                ),
              ),
            );
          }).whenComplete(() {
        setState(() {
          menuOpen = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
                                showImageSource(context);
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.close_rounded),
                              color: Colors.white70,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  menuOpen = !menuOpen;
                                });
                                if (menuOpen) {
                                  Navigator.of(context).pop();
                                }
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
                          query['q'] = searchField.text;
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
            text: "23",
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
        ElevatedButton(
            onPressed: () async {
              position(context);
            },
            child: Text('get position'))
      ],
    );
  }
}
