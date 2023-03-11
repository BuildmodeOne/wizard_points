import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'dart:collection';
import 'package:localstorage/localstorage.dart';
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

  bool isRoundFinished() {
    if (currentRound == 0) {
      return false;
    }

    var round = rounds[currentRound - 1];

    return round.results.length == players.length;
  }

  void newRound() {
    if (currentRound >= getMaxRounds()) {
      return;
    }

    currentRound++;

    rounds.add(Round());

    // dont change dealer on first round
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

    return index;
  }

  int getCurrentFirstPredictor() {
    return getBoundedIndex((dealer ?? 0) + 1);
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

@JsonSerializable()
class GameSettings {
  bool alwaysRewardTricks = false;
  bool allowZeroPrediction = false;
  bool plusMinusOneVariant = false;

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

  int getPoints(int playerIndex, GameSettings settings) {
    int points = 0;
    var correctPrediction = predictions[playerIndex] == results[playerIndex];

    if (correctPrediction) {
      points += settings.pointsForCorrectPrediction;
    }

    if (settings.alwaysRewardTricks || correctPrediction) {
      points += (results[playerIndex] ?? 0) * settings.pointsForTricks;
    }

    points +=
        ((predictions[playerIndex] ?? 0) - (results[playerIndex] ?? 0)).abs() *
            -settings.pointsForTricks;

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
