import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final double lat;
  final double lon;
  final String timezone;
  final double timezone_offset;
  final Current current;

  WeatherModel({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezone_offset,
    required this.current,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return _$WeatherModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@JsonSerializable()
class Current {
  final double dt;
  final double sunrise;
  final double sunset;
  final double temp;
  final double feels_like;
  final double pressure;
  final double humidity;
  final double dew_point;
  final double uvi;
  final double clouds;
  final double visibility;
  final double wind_speed;
  final double wind_deg;
  final double wind_gust;
  final List<Weather> weather;

  Current({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feels_like,
    required this.pressure,
    required this.humidity,
    required this.dew_point,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.wind_speed,
    required this.wind_deg,
    required this.wind_gust,
    required this.weather,
  });

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

@JsonSerializable()
class Weather {
  final double id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
