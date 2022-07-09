import 'package:flutter/material.dart';
import 'package:weather/getData.dart';

class MyData extends ChangeNotifier {
  late WeatherData dataModel;

  fetchInfo(context) async {
    dataModel = WeatherAPI().callApi(context) as WeatherData;
    notifyListeners();
  }
}

void getdates() {
  for (dynamic dates in forcast["list"]) {
    print(dates["dt_txt"]);
  }
}

Map<String, dynamic> forcast = {
  "cod": "200",
  "message": 0,
  "cnt": 3,
  "list": [
    {
      "dt": 1656255600,
      "main": {
        "temp": 307.88,
        "feels_like": 311.76,
        "temp_min": 306.21,
        "temp_max": 307.88,
        "pressure": 1001,
        "sea_level": 1001,
        "grnd_level": 995,
        "humidity": 46,
        "temp_kf": 1.67
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "description": "overcast clouds",
          "icon": "04n"
        }
      ],
      "clouds": {"all": 100},
      "wind": {"speed": 6.84, "deg": 84, "gust": 9.63},
      "visibility": 10000,
      "pop": 0,
      "sys": {"pod": "n"},
      "dt_txt": "2022-06-26 15:00:00"
    },
    {
      "dt": 1656266400,
      "main": {
        "temp": 306.25,
        "feels_like": 310.87,
        "temp_min": 305.01,
        "temp_max": 306.25,
        "pressure": 1002,
        "sea_level": 1002,
        "grnd_level": 996,
        "humidity": 54,
        "temp_kf": 1.24
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "description": "overcast clouds",
          "icon": "04n"
        }
      ],
      "clouds": {"all": 100},
      "wind": {"speed": 6.29, "deg": 94, "gust": 10.48},
      "visibility": 10000,
      "pop": 0.02,
      "sys": {"pod": "n"},
      "dt_txt": "2022-06-26 18:00:00"
    },
    {
      "dt": 1656277200,
      "main": {
        "temp": 303.95,
        "feels_like": 308.57,
        "temp_min": 303.95,
        "temp_max": 303.95,
        "pressure": 1002,
        "sea_level": 1002,
        "grnd_level": 995,
        "humidity": 64,
        "temp_kf": 0
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "description": "overcast clouds",
          "icon": "04n"
        }
      ],
      "clouds": {"all": 100},
      "wind": {"speed": 4.36, "deg": 93, "gust": 7.89},
      "visibility": 10000,
      "pop": 0.12,
      "sys": {"pod": "n"},
      "dt_txt": "2022-06-26 21:00:00"
    }
  ],
  "city": {
    "id": 1255927,
    "name": "Siwān",
    "coord": {"lat": 26.2167, "lon": 84.3667},
    "country": "IN",
    "population": 119181,
    "timezone": 19800,
    "sunrise": 1656199916,
    "sunset": 1656249509
  }
};
