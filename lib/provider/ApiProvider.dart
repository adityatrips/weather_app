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
    var now = DateTime.now().millisecondsSinceEpoch;
    box.writeInMemory("lastApiCalled", now);
    log(dotenv.env["OWM_API"]!);
    getWeather();
  }

  WeatherModel? weather;

  Position? position;
  String? cityName;
  double? temperature;
  String? description;
  String? main;

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
    int lastApiCalled = box.read("lastApiCalled");

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
      description = box.read("description");
      main = box.read("main");

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
      temperature = weather!.current.temp;
      description = weather!.current.weather[0].description.toUpperCase();
      main = weather!.current.weather[0].main;

      log("${position!.latitude}, ${position!.longitude}");
      log("${weather!.current.temp}");
      log("$cityName");

      box.writeInMemory("cityName", cityName!);
      box.writeInMemory("temperature", weather!.current.temp);
      box.writeInMemory("description", description!);
      box.writeInMemory("main", main!);
    } catch (e) {
      weather = null;
      cityName = box.read("cityName");
      temperature = box.read("temperature");
    } finally {
      notifyListeners();
    }
  }
}
