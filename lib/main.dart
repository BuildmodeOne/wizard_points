import 'dart:math';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/services/models.dart';

import 'services/config.dart';

void main() {
  var storage = LocalStorage('wizard_points');

  Game getGame() {
    var localGame = storage.getItem('game');
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
      game.dealer = max(roundIndex % game.players.length - 1, 0);

      // clear game if saved game is finished
      if (game.currentRound == game.getMaxRounds()) {
        game = Game();
        game.saveGame();
      }
    } else {
      // game = Game.createDevGame();
      game = Game();
    }
    return game;
  }

  GameSettings getGameSettings() {
    var localSettings = storage.getItem('settings');

    if (localSettings != null) {
      var gameSettings = GameSettings.fromJson(localSettings);

      return gameSettings;
    }

    var gameSettings = GameSettings();
    storage.setItem('settings', gameSettings.toJson());
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

    // //  temp:
    // var devGame =
    //     '{"players":["Jutta","Stefan","Johanna","Daniel","Philipp","Eva"],"rounds":[{"currentTrick":0,"predictions":{"1":0,"2":0,"3":0,"4":0,"5":0,"0":0},"results":{"0":1,"1":0,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":1,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":2,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":3,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":4,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":5,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":6,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":7,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}},{"currentTrick":8,"predictions":{"2":0,"3":0,"4":0,"5":0,"0":0,"1":0},"results":{"0":1,"1":1,"2":0,"3":0,"4":0,"5":0}}],"dealer":1,"settings":{"alwaysRewardTricks":false,"allowZeroPrediction":false,"pointsForTricks":10,"pointsForCorrectPrediction":20},"currentRound":10}';
    // game = Game.fromJson(jsonDecode(devGame));
    // game.settings = widget.game.settings;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wizard Points',
      home: PlayerCreationScreen(
        game: game,
      ),
      // home: GameFinishedScreen(
      //   game: game,
      // ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 107, 7, 6),
            brightness: themeNotifier.currentTheme()),
        useMaterial3: true,
        // fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
        //     ? '-apple-system'
        //     : null,
      ),
    );
  }
}
