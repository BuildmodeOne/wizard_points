import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';
part 'models.g.dart';

@JsonSerializable()
class Game {
  List<Player> players = List.empty(growable: true);
  List<Round> rounds = List.empty(growable: true);

  Player? dealer;

  Game();

  static Game createDevGame() {
    var game = Game();
    game.players.add(Player(name: 'Player 1'));
    game.players.add(Player(name: 'Player 2'));
    game.players.add(Player(name: 'Player 3'));
    game.players.add(Player(name: 'Player 4'));
    game.players.add(Player(name: 'Player 5'));
    game.players.add(Player(name: 'Player 6'));

    game.dealer = game.players[0];

    return game;
  }

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
      scores[player] = rounds
          .sublist(0, currentRound - 1)
          .map((e) => e.getPoints(player))
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
      dealer = players[0];
    } else {
      var dealerIndex = players.indexOf(dealer!) + 1;
      if (dealerIndex >= players.length) {
        dealerIndex = 0;
      }
      dealer = players[dealerIndex];
    }

    saveGame();
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

@JsonSerializable()
class Round {
  int currentTrick = 0;

  Map<int, int> predictions = {};
  Map<int, int> results = {};

  int getPoints(Player player) {
    int points = 0;

    if (predictions[player] == results[player]) {
      points += 20;
    }

    points += (results[player] ?? 0) * 10;

    points += ((predictions[player] ?? 0) - (results[player] ?? 0)).abs() * -10;

    return points;
  }

  Round();

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}

@JsonSerializable()
class Player {
  String name;
  int points;

  Player({this.name = 'Tap to edit', this.points = 0});

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
