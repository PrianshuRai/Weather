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
