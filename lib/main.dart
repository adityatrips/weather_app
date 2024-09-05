import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/ThemeProvider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:weather_app/screens/weather_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
  await GetStorage.init();
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      builder: (context, _) {
        final theme = Provider.of<ThemeProvider>(context);

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather app',
          theme: theme.getTheme(),
          home: const SafeArea(child: WeatherPage()),
        );
      },
    );
  }
}
