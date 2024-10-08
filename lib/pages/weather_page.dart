import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/ApiProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String formatDate(double dateTime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime.toInt());
    return "${date.hour}:${date.minute}";
  }

  _getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/clear.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'assets/clear.json';
      case 'clouds':
        return 'assets/cloud.json';
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/haze_dust_fog.json';
      case 'mist':
      case 'smoke':
        return 'assets/mist_smoke.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain_drizzle_showerrain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/clear.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ApiNotifier?>()?.weather;
    final temperature = context.watch<ApiNotifier?>()?.temperature;
    final cityName = context.watch<ApiNotifier?>()?.cityName;
    final description = context.watch<ApiNotifier?>()?.description;
    final main = context.watch<ApiNotifier?>()?.main;

    if (data == null ||
        temperature == null ||
        cityName == null ||
        description == null ||
        main == null) {
      context.read<ApiNotifier>().getWeather();

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ApiNotifier>().getWeather();
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Please consider clicking the ad above. I won't force you to do it, but it would be nice if you did. I am a student and I need to pay my bills. Thanks for your support!",
            style: GoogleFonts.dmSans(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            description!,
            style: GoogleFonts.oswald(
              fontSize: 60,
            ),
            textAlign: TextAlign.center,
          ),
          Lottie.asset(
            _getWeatherAnimation(
              main,
            ),
            animate: true,
            fit: BoxFit.cover,
          ),
          Text(
            cityName!,
            style: GoogleFonts.dmSans(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${temperature!} °C",
            style: GoogleFonts.oswald(
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
