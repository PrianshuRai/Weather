import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/customWidgets.dart';
import 'package:weather/getData.dart';
import 'package:weather/methods.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool menuOpen = false;
  // bool _celcius = false;
  WeatherAPI data = WeatherAPI();
  GetLocation currentLocation = GetLocation();
  late dynamic weatherDetails;
  late Future<WeatherData> report;
  TextEditingController searchField = TextEditingController();

  Future<WeatherData> _getData() async {
    await currentLocation.getCoordinates(context);
    final prefs = await SharedPreferences.getInstance();
    final String? latitude = prefs.getString("lat");
    final String? longitude = prefs.getString("lon");
    return await data.callApi(context,
        latitude: latitude, longitude: longitude);
    // weatherDetails = WeatherData();
    // return weatherDetails;
  }

  // settings bottom sheet
  Future<dynamic> settingsMenu(BuildContext context) async {
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
                              children: <Widget>[
                                Text(
                                  'Settings',
                                  style: GoogleFonts.lato(
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
                            // TODO: make a stateful switchbar
                            // SwitchTile(switchValue: _celcius, valueChanged: valueChanged)
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
  void initState() {
    super.initState();
    // get data from longitude and longitude on first startup
    // if the searchterm is not available, run this
    if (searchField.text.isEmpty) {
      report = _getData();
    } else {
      report = data.callApi(context, searchterm: searchField.text);
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
                                settingsMenu(context);
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
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) {
                            if (searchField.text.isNotEmpty) {
                              setState(() {
                                report = data.callApi(context,
                                    searchterm: searchField.text);
                              });
                            }
                            ;
                          },
                          autocorrect: true,
                          style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline5,
                              // fontSize: 18,
                              color: Colors.white70),
                          decoration: const InputDecoration(
                              hintText: "Search",
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
                          if (searchField.text.isNotEmpty) {
                            setState(() {
                              report = data.callApi(context,
                                  searchterm: searchField.text);
                            });
                          }
                          print("done");
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
        FutureBuilder<WeatherData>(
            future: report,
            builder: (context, theData) {
              if (theData.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: "${theData.data?.feels_like.round()}",
                        style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline1,
                            color: Colors.white.withOpacity(.7),
                            fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(
                            text: '\u00B0',
                            style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline1,
                                color: Colors.white.withOpacity(.7),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 4
                                // fontSize: 30,
                                ),
                          ),
                          query["units"] == 'metric'
                              ? TextSpan(
                                  text: 'C',
                                  style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.headline1,
                                    color: Colors.white.withOpacity(.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : query["units"] == "imperial"
                                  ? TextSpan(
                                      text: "F",
                                      style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                        color: Colors.white.withOpacity(.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : TextSpan(
                                      text: "K",
                                      style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                        color: Colors.white.withOpacity(.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * .25,
                      color: Colors.transparent,
                      child: BlurContainer(
                        myParam: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "${theData.data?.place}",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline6,
                                fontSize: 16,
                                color: Colors.white.withOpacity(.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.place_outlined,
                              color: Colors.white.withOpacity(.6),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // used for testing of forcast data, remove once done....
                    // ElevatedButton(
                    //     onPressed: () {
                    //       getdates();
                    //       print("\n\n************** end *********************");
                    //     }, child: Text("get a date"))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .37,
                      child: ListView(
                        shrinkWrap: true,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 7, left: 15, right: 3, bottom: 7),
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width * .45,
                                    child: BlurContainer(
                                      myParam: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.local_fire_department,
                                                color: Colors.white.withOpacity(.8),
                                                size: 28,
                                              ),
                                              // const SizedBox(width: 10,),
                                              Text("Max Temp",
                                                style: GoogleFonts.lato(
                                                  textStyle: Theme.of(context).textTheme.headline5,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w400,
                                                ),)
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("${theData.data?.max.toInt().toString()}\u00B0",
                                            style: GoogleFonts.lato(
                                              textStyle: Theme.of(context).textTheme.headline4,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600,
                                            ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7, left: 3, right: 15, bottom: 7),
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width * .45,
                                    child: BlurContainer(
                                      myParam: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.ac_unit,
                                                color: Colors.white.withOpacity(.8),
                                                size: 28,
                                              ),
                                              // const SizedBox(width: 10,),
                                              Text("Min Temp",
                                                style: GoogleFonts.lato(
                                                  textStyle: Theme.of(context).textTheme.headline5,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w400,
                                                ),)
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("${theData.data?.min.toInt().toString()}\u00B0",
                                            style: GoogleFonts.lato(
                                              textStyle: Theme.of(context).textTheme.headline4,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600,
                                            ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                            WeatherList(
                                icons: Icons.description_rounded,
                                header: "Description",
                                values:
                                "${theData.data?.description}"),
                            WeatherList(
                                icons: Icons.local_fire_department,
                                header: "Max Temperature",
                                values:
                                    "${theData.data?.max.toInt().round().toString()}\u00B0"),
                            WeatherList(
                                icons: Icons.ac_unit,
                                header: "Min Temperature",
                                values:
                                "${theData.data?.min.toInt().round().toString()}\u00B0")

                          ],
                      ),
                    )
                  ],
                );
              } else if (theData.hasError) {
                return Center(
                    child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  height: 350,
                  width: MediaQuery.of(context).size.width * .93,
                  color: Colors.transparent,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
                          child: Text(
                            "Error while starting the app \n${theData.error}",
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              color: Colors.white.withOpacity(.7),
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                  ),
                ));
              } else {
                return Center(
                    child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  height: 200,
                  width: MediaQuery.of(context).size.width * .93,
                  color: Colors.transparent,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
                          child: Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.black12,
                              strokeWidth: 7.3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue.shade100),
                            ),
                          )),
                    ),
                  ),
                ));
              }
            })
      ],
    );
  }
}
