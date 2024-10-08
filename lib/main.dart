import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ads/banner_ad_unit.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/provider/ApiProvider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;

  void requestPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status == PermissionStatus.denied) {
      await Geolocator.openLocationSettings();
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiNotifier()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather app',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.blue,
            onPrimary: Colors.white,
            primaryContainer: Colors.blue,
            onPrimaryContainer: Colors.white,
            secondary: Colors.blue,
            onSecondary: Colors.white,
            secondaryContainer: Colors.blue,
            onSecondaryContainer: Colors.white,
            error: Colors.redAccent,
            onError: Colors.red,
            errorContainer: Colors.redAccent,
            onErrorContainer: Colors.white,
            outline: Color.fromRGBO(189, 189, 189, 1),
            surface: Color.fromRGBO(33, 33, 33, 1),
            onSurface: Colors.white,
            onSurfaceVariant: Colors.white,
          ),
        ),
        home: const SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                    top: 75,
                    left: 0,
                    right: 0,
                    child: WeatherPage(),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: BannerAdUnit(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
