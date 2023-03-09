// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/services/models.dart';

import 'services/config.dart';

void main() {
  late Game game;

  var storage = LocalStorage("wizard_points");
  var localGame = storage.getItem("game");
  if (localGame != null) {
    print("Loading game from local storage");
    game = Game.fromJson(localGame);

    // replay round because it's only partially saved
    game.currentRound -= 1;
  } else {
    print("Creating new game");
    game = Game.createDevGame();
  }

  runApp(WizardPointApp(
    game: game,
  ));
}

class WizardPointApp extends StatefulWidget {
  const WizardPointApp({Key? key, required this.game}) : super(key: key);

  final Game game;

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
    var game = widget.game;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digitale Backwarenbestellung',
      home: PlayerCreationScreen(
        game: game,
      ),
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
