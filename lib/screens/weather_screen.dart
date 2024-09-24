import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/provider/ThemeProvider.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(
    dotenv.env["OWM_API"]!,
  );
  Weather? _weather;
  bool loading = true;

  _fetchWeather() async {
    setState(() {
      loading = true;
    });

    Position cityPosition = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityPosition);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
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
  void initState() {
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          theme.toggleTheme();
        },
        shape: const CircleBorder(),
        child: theme.isDarkMode
            ? const Icon(Icons.light_mode)
            : const Icon(Icons.dark_mode),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchWeather();
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  _weather?.cityName ?? "...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.bold,
                    fontSize: 64,
                  ),
                ),
                Lottie.asset(_getWeatherAnimation(_weather?.mainCondition)),
                Text(
                  _weather?.temperature.round() == null
                      ? "..."
                      : "${_weather?.temperature.round()}°",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Consider clicking on the ad to support my work! I won't force you to, but it would be highly appreciated!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
