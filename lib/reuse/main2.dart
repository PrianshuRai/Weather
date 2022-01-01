import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

String APIkey = 'e00915bd6553ef76ab54a9a666f822fe';

// give request parameters here
// this will change the data properties
// from API response
final query = {
  "q": 'New Delhi, India',
  "appid": APIkey,
  "units": 'metric' // imperial for F and metric for Calcius
};

void main2() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  // user typed search field
  TextEditingController searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * .98,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/cloudy.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
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
                            const Icon(
                              Icons.menu,
                              color: Colors.white30,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: searchField,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont('Lato',
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                    // fontSize: 18,
                                    color: Colors.white70),
                                decoration: const InputDecoration(
                                    hintText: "New Delhi, India",
                                    border: InputBorder.none),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search,
                                  color: Colors.white70),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
Future<dynamic> callApi() async {
  final link = Uri.https('api.openweathermap.org', '/data/2.5/weather',
      query); //?q=delhi&appid=${APIkey}';
  var request = await http.get(link);
  if (request.statusCode == 200) {
    var data = jsonDecode(request.body);
    if (kDebugMode) {
      print(data);
    }
    return data;
  } else {
    if (kDebugMode) {
      print(
          'something is wrong code===${request.statusCode} \nbody=== ${request.body}');
    }
  }
}