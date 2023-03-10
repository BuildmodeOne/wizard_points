import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';
part 'models.g.dart';

@JsonSerializable()
class Game {
  List<Player> players = List.empty(growable: true);
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
    storage.setItem("game", toJson());
  }

  Map<Player, int> getScores() {
    var scores = <Player, int>{};

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

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

@JsonSerializable()
class GameSettings {
  bool alwaysRewardTricks = true;
  bool allowZeroPrediction = false;

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

@JsonSerializable()
class Player {
  String name;
  int points;

  Player({this.name = 'Tap to edit', this.points = 0});

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
