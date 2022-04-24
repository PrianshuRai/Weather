import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String apiKey = 'e00915bd6553ef76ab54a9a666f822fe';

final query = {
  "q": 'New Delhi, India',
  "lat": null,
  "lon": null,
  "appid": apiKey,
  "units": 'metric'// imperial for F and metric for Calcius
};

class WeatherAPI {
  Future<dynamic> callApi(
      {String? searchterm, double? longitude, double? latitude}) async {
    print("func started");
    // assigning the values in <Map> query
    query["q"] = searchterm;
    if (longitude != null) {
      query["lon"] = longitude as String;
      query["lat"] = latitude as String;
    }
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
      return null;
    }
  }
}

class WeatherData {
  late double? feels_like;
  late String? place;
  late String? description;
  late double? max;
  late double? min;
  late int? pressure;
  late int? humidity;
  late int? visibility;
  late double? windSpeed;
  late int? windDirection;

  WeatherData(
      {this.feels_like,
      this.place,
      this.description,
      this.max,
      this.min,
      this.pressure,
      this.humidity,
      this.visibility,
      this.windSpeed,
      this.windDirection});

  WeatherData.fromJson(Map<String, dynamic> json) {
    feels_like = json['main']['temp_min'];
    description = json['weather'][0]['description'];
    max = json['main']['temp_max'];
    min = json['main']['temp_min'];
    pressure = json['main']['pressure'];
    humidity = json['main']['humidity'];
    visibility = json['visibility'];
    windSpeed = json['wind']['speed'];
    windDirection = json['wind']['deg'];
  }
}
