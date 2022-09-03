import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiKey = 'e00915bd6553ef76ab54a9a666f822fe';

final query = {
  "q": 'New Delhi, India',
  "lat": null,
  "lon": null,
  "appid": apiKey,
  "units": 'metric' // imperial for F and metric for Calcius
};

class WeatherAPI {
  Future<WeatherData> callApi(context,
      {String? searchterm, String? longitude, String? latitude}) async {
    print("func started");
    // assigning the values in <Map> query
    query["q"] = searchterm;
    // if (longitude != null) {
    query["lon"] = longitude;
    query["lat"] = latitude;
    // }
    print("query *** $query");

    // connect to the openweathermap URL
    final link = Uri.https('api.openweathermap.org', '/data/2.5/weather',
        query); //?q=delhi&appid=${APIkey}';
    var request = await http.get(link);
    if (request.statusCode == 200) {
      var data = jsonDecode(request.body);
      print("data== $data");
      WeatherData weatherStatus = WeatherData.fromJson(data);
      print("weatherStatus saved to the class $weatherStatus");
      return weatherStatus;
    } else {
      if (kDebugMode) {
        print(
            'something is wrong code===${request.statusCode} \nbody=== ${request.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occured"),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      throw Exception("Failed to load data to the class");
      // return ;
    }
  }
}

class WeatherData {
  final double feels_like;
  final String place;
  final String main;
  final String description;
  final String icon;
  final double max;
  final double min;
  final int pressure;
  final int humidity;
  final int visibility;
  final double windSpeed;
  final int windDirection;
  final String country;

  const WeatherData(
      {required this.feels_like,
      required this.place,
      required this.main,
      required this.description,
      required this.icon,
      required this.max,
      required this.min,
      required this.pressure,
      required this.humidity,
      required this.visibility,
      required this.windSpeed,
      required this.windDirection,
      required this.country});

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
      feels_like: json['main']['feels_like'],
      place: json['name'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      max: json['main']['temp_max'],
      min: json['main']['temp_min'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'],
      windDirection: json['wind']['deg'],
      country: json['sys']['country']);
}
