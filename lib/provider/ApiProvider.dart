import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ApiNotifier {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.openweathermap.org",
      queryParameters: {
        "appid": dotenv.env["OWM_API"]!,
        "units": "metric",
        "exclude": "daily,hourly",
      },
    ),
  );

  ApiNotifier() {
    getWeather();
  }

  WeatherModel? weather;

  Position? position;
  String? cityName;

  Future<void> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 500,
      ),
    );
    final locationDetails = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    this.position = position;
    this.cityName = locationDetails[0].locality;
  }

  Future<void> getWeather() async {
    try {
      await getPosition();
      final response = await dio.get(
        "/data/3.0/onecall",
        queryParameters: {
          "lat": position!.latitude,
          "lon": position!.longitude,
        },
      );

      weather = WeatherModel.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      weather = null;
    }
  }
}
