import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ApiNotifier extends ChangeNotifier {
  final int lastApiCalled = DateTime.now().millisecondsSinceEpoch;
  final int apiInterval = 1000 * 60 * 10;

  final box = GetStorage();

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
    log(dotenv.env["OWM_API"]!);
    getWeather();
  }

  WeatherModel? weather;

  Position? position;
  String? cityName;
  double? temperature;

  Future<void> getPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    final locationDetails = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    this.position = position;
    this.cityName = locationDetails[0].locality;
  }

  Future<void> getWeather() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if ((currentTime - lastApiCalled < apiInterval) && weather != null) {
      log("API call skipped to respect interval");
      Get.snackbar(
        "Error",
        "API call skipped to respect interval, using cached data.",
      );
      weather = null;
      cityName = box.read("cityName");
      temperature = box.read("temperature");
      return;
    }

    try {
      await getPosition();
      final response = await dio.get(
        "/data/3.0/onecall",
        queryParameters: {
          "lat": position!.latitude,
          "lon": position!.longitude,
        },
      );

      log("API Called");

      weather = WeatherModel.fromJson(response.data);
      log("${position!.latitude}, ${position!.longitude}");
      log("${weather!.current.temp}");
      log("$cityName");

      box.writeInMemory("cityName", cityName!);
      box.writeInMemory("temperature", weather!.current.temp);
    } catch (e) {
      weather = null;
      cityName = box.read("cityName");
      temperature = box.read("temperature");
    } finally {
      notifyListeners();
    }
  }
}
