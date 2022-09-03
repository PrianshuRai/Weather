import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weather/landing.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.latoTextTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/cloudy.jpg"), fit: BoxFit.cover),
        ),
        child: Landing(),
      ),
    );
  }
}

String apiKey = 'e00915bd6553ef76ab54a9a666f822fe';

final query = {
  "q": 'New Delhi, India',
  "appid": apiKey,
  "units": 'metric' // imperial for F and metric for Calcius
};

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
