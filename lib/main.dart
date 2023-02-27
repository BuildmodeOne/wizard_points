// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/screens/start.dart';

import 'services/config.dart';

void main() {
  runApp(const WizardPointApp());
}

class WizardPointApp extends StatefulWidget {
  const WizardPointApp({Key? key}) : super(key: key);

  @override
  State<WizardPointApp> createState() => _WizardPointAppState();
}

class _WizardPointAppState extends State<WizardPointApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(() {
      setState(() {});
    });

    loadThemePref();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('theme') ?? false;
    themeNotifier.setTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digitale Backwarenbestellung',
      home: const PlayerCreationScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 107, 7, 6),
            brightness: themeNotifier.currentTheme()),
        useMaterial3: true,
        fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
            ? '-apple-system'
            : null,
        // appBarTheme: const AppBarTheme(
        //   color: Color.fromARGB(255, 94, 94, 110),
        //   //other options
        // ),
      ),
      // darkTheme: ThemeData(
      //   colorSchemeSeed: const Color.fromARGB(255, 100, 158, 97),
      //   useMaterial3: true,
      //   brightness: Brightness.dark,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
    );
  }
}
