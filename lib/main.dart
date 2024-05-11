import 'package:flutter/material.dart';
import 'package:voice_recorder/home_screen.dart';
import 'package:voice_recorder/screens/bayans.dart';
import 'package:voice_recorder/screens/my_favorites.dart';
import 'package:voice_recorder/screens/recordings_screen.dart';
import 'package:voice_recorder/screens/youtube_naat.dart';

import 'screens/naat_collections.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 64, 245, 23));
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
      color: kColorScheme.onSecondaryContainer,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: kColorScheme.onPrimaryContainer.withOpacity(0.9),
          foregroundColor: kColorScheme.onSecondary,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: kColorScheme.onSecondary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) => kColorScheme.primaryContainer,
            ),
          ),
        ),
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
        cardTheme: CardTheme(
          color: kColorScheme.onSecondaryContainer.withOpacity(0.6),
          elevation: 10,
          shadowColor: Colors.yellowAccent,
          margin: const EdgeInsets.all(4),
          surfaceTintColor: Colors.blue,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/homePage': (context) => const HomeScreen(),
        '/recordings': (context) => const RecordingsScreen(),
        '/favPage': (context) => const MyFavoritesScreen(),
        '/naatPage': (context) => NaatCollections(),
        '/bayan': (context) => const BayansScreen(),
        '/youtube': (context) => const YouTubeNaat(),
      },
    );
  }
}
