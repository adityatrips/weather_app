import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/global/state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(
    const String.fromEnvironment(
      'OPENWEATHERMAP_API_KEY',
      defaultValue: "",
    ),
  );
  Weather? _weather;
  bool loading = true;

  _fetchWeather() async {
    setState(() {
      loading = true;
    });

    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
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
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        OutlinedButton.icon(
          onPressed: () {
            _fetchWeather();
          },
          icon: const Icon(
            Icons.refresh,
          ),
          label: Text(
            "Refresh",
            style: GoogleFonts.bebasNeue(),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Get.find<ThemeController>().toggleTheme();
          },
          icon: Obx(
            () => Icon(
              Get.find<ThemeController>().isDarkMode.value
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          label: Text(
            "Toggle theme",
            style: GoogleFonts.bebasNeue(),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            await launchUrl(
              Uri.parse("https://github.com/adityatrips"),
              browserConfiguration: const BrowserConfiguration(
                showTitle: true,
              ),
            );
          },
          icon: const Icon(
            Icons.person_rounded,
          ),
          label: Text(
            "Meet the developer",
            style: GoogleFonts.bebasNeue(),
          ),
        )
      ],
      body: SafeArea(
        child: Center(
          child: loading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Get.theme.primaryColor,
                  size: 50,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  ],
                ),
        ),
      ),
    );
  }
}
