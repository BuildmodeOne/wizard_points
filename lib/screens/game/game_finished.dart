import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard_widget.dart';
import 'package:wizard_points/services/models.dart';
import 'package:wizard_points/shared/appbar.dart';

class GameFinishedScreen extends StatefulWidget {
  final Game game;
  const GameFinishedScreen({super.key, required this.game});

  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreenState();
}

class _GameFinishedScreenState extends State<GameFinishedScreen> {
  final confettiController = ConfettiController();

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    var winner = widget.game.getWinner();

    void updatePage() {
      setState(() {});
    }

    return Scaffold(
      appBar: getAppBar(
          context, 'Wizard Points', false, false, widget.game, updatePage),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ConfettiWidget(
                numberOfParticles: 25,
                emissionFrequency: 0.013,
                shouldLoop: true,
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Winner: ${winner.key}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${winner.value} points',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          var newGame = Game();
                          newGame.players = widget.game.players;
                          newGame.dealer = 0;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerCreationScreen(
                                game: newGame,
                              ),
                            ),
                            (_) => false,
                          );
                        },
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('New Game'),
                      ),
                    ),
                    ScoreboardWidget(
                      game: widget.game,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
