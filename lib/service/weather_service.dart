import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey;
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  WeatherService(this.apiKey);

  Future<Weather> getWeather(Position position) async {
    log('$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');

    final response = await http.get(
      Uri.parse(
        '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> getCurrentCity() async {
    Permission locationPermission = Permission.location;
    PermissionStatus status = await locationPermission.request();

    log(status.name);

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await locationPermission.request();
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
