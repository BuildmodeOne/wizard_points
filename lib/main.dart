// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/services/models.dart';

import 'services/config.dart';

void main() {
  var storage = LocalStorage("wizard_points");

  Game getGame() {
    var localGame = storage.getItem("game");
    late Game game;

    if (localGame != null) {
      game = Game.fromJson(localGame);

      var roundIndex =
          game.rounds.where((element) => element.results.isNotEmpty).length;

      game.rounds
          .where((element) => element.results.isEmpty)
          .forEach((element) {
        element.predictions.clear();
      });

      game.currentRound = roundIndex;
      game.dealer = roundIndex % game.players.length - 1;
    } else {
      // game = Game.createDevGame();
      game = Game();
    }
    return game;
  }

  GameSettings getGameSettings() {
    var localSettings = storage.getItem("settings");

    if (localSettings != null) {
      var gameSettings = GameSettings.fromJson(localSettings);

      return gameSettings;
    }

    var gameSettings = GameSettings();
    storage.setItem("settings", gameSettings.toJson());
    return gameSettings;
  }

  runApp(FutureBuilder(
    future: storage.ready,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var game = getGame();
        game.settings = getGameSettings();

        return WizardPointApp(
          game: game,
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
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
