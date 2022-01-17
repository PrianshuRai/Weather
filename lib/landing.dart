import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/main.dart';
import 'package:weather/position.dart';

TextStyle getFont(TextStyle? values, BuildContext context,
    {color: Colors, size: Size}) {
  return GoogleFonts.getFont(
    "Lato",
    textStyle: Theme.of(context).textTheme.bodyText1,
  );
}
//TODO functio for TextStyle

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  TextEditingController searchField = TextEditingController();
  bool menuOpen = false;

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
                          Color(0xFFFFEBEE).withOpacity(0.6), //BBDEFB
                          Color(0xFFE3F2FD).withOpacity(0.6) // FFCDD2
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              size: 60,
                              color: Colors.white70,
                              semanticLabel: "Take image from Camera",
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 60.0, bottom: 60.0),
                          child: VerticalDivider(
                            thickness: 1.5,
                            width: 1,
                            color: Colors.black12,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.crop_original,
                              size: 60,
                              color: Colors.white70,
                              semanticLabel: "Choose image from Gallery",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
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
                                  // showImageSource(context);
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
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              print(position);
            },
            child: Text('get position'))
      ],
    );
  }
}
