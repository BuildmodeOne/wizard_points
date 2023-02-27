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
}
