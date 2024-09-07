import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:susu_games/pages/home.dart';
import 'package:susu_games/pages/memory_pattern/memory_pattern_game.component.dart';
import 'package:susu_games/pages/simple_math/simple_math.component.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData(brightness: Brightness.dark);

    return MaterialApp(
      title: 'SuSu Games',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return CustomPageRoute.createPageRoute(const HomePage());
          case '/memory_pattern':
            return CustomPageRoute.createPageRoute(const MemoryPatternPage());
          case '/simple_math':
            return CustomPageRoute.createPageRoute(const SimpleMathPage());
          default:
            return null;
        }
      },
    );
  }
}
