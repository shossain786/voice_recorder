import 'package:flutter/material.dart';
import 'package:voice_recorder/home_screen.dart';
import 'package:voice_recorder/screens/my_favorites.dart';
import 'package:voice_recorder/screens/naat_lists.dart';
import 'package:voice_recorder/screens/recordings_screen.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.red);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Recorder',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onSecondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => kColorScheme.primaryContainer,
          ),
        )),
        buttonTheme: ButtonThemeData(
          buttonColor: kColorScheme.onSecondaryContainer,
          focusColor: kColorScheme.onSecondaryContainer,
          highlightColor: kColorScheme.onPrimary,
          shape: CircleBorder(
            side: BorderSide(
              style: BorderStyle.solid,
              color: kColorScheme.onPrimaryContainer,
            ),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/homePage': (context) => const HomeScreen(),
        '/recordings': (context) => const RecordingsScreen(),
        '/favPage': (context) => const MyFavoritesScreen(),
        '/naatPage': (context) => const MyNaatScreen(),
      },
    );
  }
}
