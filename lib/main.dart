import 'package:flutter/material.dart';
import 'package:voice_recorder/screens/bayans.dart';

import 'screens/home_screen.dart';
import 'screens/youtube_videos.dart';
import 'screens/naat_collections.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
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
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => kColorScheme.primaryContainer,
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
      home: const VoiceRecorderApp(),
      routes: {
        '/homePage': (context) => const VoiceRecorderApp(),
        '/naatPage': (context) => NaatCollections(),
        '/bayan': (context) => BayansScreen(),
        '/youtube': (context) => const VideoList(),
      },
    );
  }
}
