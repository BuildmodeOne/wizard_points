class Game {
  List<Player> players = List.empty(growable: true);
  List<Round> rounds = List.empty(growable: true);

  static Game createDevGame() {
    var game = Game();
    game.players.add(Player(name: 'Player 1'));
    game.players.add(Player(name: 'Player 2'));
    game.players.add(Player(name: 'Player 3'));

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

  void newRound() {
    if (currentRound < getMaxRounds()) {
      currentRound++;
      rounds.add(Round());
    }
  }
}

class Player {
  String name;
  int points;

  Player({this.name = 'Tap to edit', this.points = 0});
}

class Round {
  int currentTrick = 0;
  Map<Player, int> predictions = {};
  Map<Player, int> results = {};

  int getPoints(Player player) {
    int points = 0;

    if (predictions[player] == results[player]) {
      points += 20;
    }

    points += (results[player] ?? 0) * 10;

    points += ((predictions[player] ?? 0) - (results[player] ?? 0)).abs() * -10;

    return points;
  }
}
