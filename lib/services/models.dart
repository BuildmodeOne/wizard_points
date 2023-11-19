import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';

import '../screens/player/players_screen.dart';
import '../screens/player/restart_dialog.dart';
part 'models.g.dart';

@JsonSerializable()
class Game {
  List<String> players = List.empty(growable: true);
  List<Round> rounds = List.empty(growable: true);

  int? dealer;

  GameSettings settings = GameSettings();

  Game();

  int currentRound = 0;
  int getMaxRounds() {
    if (players.isEmpty) {
      return 0;
    } else if (players.length < 4) {
      return 20;
    } else if (players.length < 5) {
      return 15;
    } else if (players.length < 6) {
      return 12;
    } else {
      return 10;
    }
  }

  void saveGame() {
    var storage = LocalStorage('wizard_points');
    storage.setItem('game', toJson());
  }

  Map<String, int> getScores() {
    var scores = <String, int>{};

    for (var player in players) {
      var index = players.indexOf(player);

      var roundCount =
          rounds.where((element) => element.results.isNotEmpty).length;

      scores[player] = rounds
          .sublist(0, roundCount)
          .map((e) => e.getPoints(index, settings))
          .fold(0, (a, b) => a + b);
    }

    return scores;

    // return Map.fromEntries(
    //     scores.entries.toList()..sort((a, b) => a.value.compareTo(b.value)));
  }

  MapEntry<String, int> getWinner() {
    var scores = getScores();

    var winner = scores.entries
        .firstWhere((element) => element.value == scores.values.reduce(max));

    return winner;
  }

  bool isRoundFinished(int roundIndex) {
    if (currentRound == 0) {
      return false;
    }

    var round = rounds[currentRound - 1];

    return round.results.length == roundIndex;
  }

  void newRound() {
    if (currentRound >= getMaxRounds()) {
      return;
    }

    currentRound++;

    rounds.add(Round());

    // don't change dealer on first round
    if (currentRound == 1) {
      return;
    }

    if (dealer == null) {
      dealer = 0;
    } else {
      dealer = (dealer ?? 0) + 1;
      if (dealer! >= players.length) {
        dealer = 0;
      }
    }

    saveGame();
  }

  int getBoundedIndex(int index) {
    if (index >= players.length) {
      index -= players.length;
    }

    if (index < 0) {
      index += players.length;
    }

    return index;
  }

  int getCurrentFirstPredictor() {
    return getBoundedIndex((dealer ?? 0) + 1);
  }

  Future<void> restartGame(Game game, BuildContext context) async {
    var dialog = await showDialog(
      context: context,
      builder: (context) => const RestartGameDialog(),
    );

    if (dialog == null || dialog == RestartDialogResult.cancel) {
      return;
    }

    late List<String> players;

    if (dialog == RestartDialogResult.keepPlayers) {
      players = this.players;
    }

    game = Game();

    if (dialog == RestartDialogResult.keepPlayers) {
      game.players = players;
      game.dealer = 0;
    }

    var storage = LocalStorage('wizard_points');
    await storage.ready;

    var settings = await storage.getItem('settings');
    if (settings != null) {
      game.settings = GameSettings.fromJson(settings);
    }

    await storage.setItem('game', game.toJson());

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerCreationScreen(
          game: game,
        ),
      ),
      (_) => false,
    );
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

@JsonSerializable()
class GameSettings {
  bool alwaysRewardTricks = false;
  bool allowZeroPrediction = false;
  bool plusMinusOneVariant = true;
  bool rewardAllTricksDespitePrediction = false;

  int pointsForTricks = 10;
  int pointsForCorrectPrediction = 20;

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GameSettingsToJson(this);

  GameSettings();

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Round {
  int currentTrick = 0;

  Map<int, int> predictions = {};
  Map<int, int> results = {};

  int getResultsCount(int playerIndex) {
    return results.entries
        .where((element) => element.value == playerIndex)
        .length;
  }

  int getPoints(int playerIndex, GameSettings settings) {
    int points = 0;
    var correctPrediction =
        predictions[playerIndex] == getResultsCount(playerIndex);

    if (correctPrediction) {
      points += settings.pointsForCorrectPrediction;
    }

    if (settings.alwaysRewardTricks || correctPrediction) {
      points += (getResultsCount(playerIndex)) * settings.pointsForTricks;
    }

    points += ((predictions[playerIndex] ?? 0) - (getResultsCount(playerIndex)))
            .abs() *
        -settings.pointsForTricks;

    if (!correctPrediction &&
        getResultsCount(playerIndex) == results.length &&
        results.length > 1 &&
        settings.rewardAllTricksDespitePrediction) {
      // override points!
      points = getResultsCount(playerIndex) * settings.pointsForTricks;
    }

    return points;
  }

  Round();

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
