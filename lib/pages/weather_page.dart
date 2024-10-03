import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/ApiProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    final cityName = context.watch<ApiNotifier?>()?.cityName;

    if (data == null) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Theme.of(context).colorScheme.primary,
          size: 75,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<ApiNotifier>().getWeather();
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Please consider clicking the ad above. I won't force you to do it, but it would be nice if you did. I am a student and I need to pay my bills. Thanks for your support!",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              data.current.weather[0].description.toUpperCase(),
              // "",
              style: GoogleFonts.oswald(
                fontSize: 60,
              ),
              textAlign: TextAlign.center,
            ),
            Lottie.asset(
              _getWeatherAnimation(
                data.current.weather[0].main,
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
              "${data.current.temp} °C",
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
}