import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'screens/splash_screen.dart';

const Color primaryColor = Color(0xFF5865F2);
const Color backgroundColor = Color(0xFFFCEFFF);
const Color cardColor = Color(0xFFF8EAF8);
const Color purpleColor = Color(0xFF8E24AA);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.init();
  await FavoriteService.init();

  runApp(const SpaceflightApp());
}

class SpaceflightApp extends StatelessWidget {
  const SpaceflightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spaceflight News',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
        ),
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}