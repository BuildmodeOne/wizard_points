import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wizard_points/screens/game/game_finished.dart';
import 'package:wizard_points/screens/round/elements/player_button.dart';
import 'package:wizard_points/screens/round/select_prediction.dart';
import 'package:wizard_points/shared/appbar.dart';
import 'package:wizard_points/shared/dealer.dart';

import '../../services/models.dart';
import '../rounds/new_section_screen.dart';
import '../scoreboard/scoreboard_widget.dart';

class TrickSelector extends StatefulWidget {
  final Game game;
  const TrickSelector({required this.game, super.key});

  @override
  State<TrickSelector> createState() => _TrickSelectorState();
}

class _TrickSelectorState extends State<TrickSelector> {
  final radius = 110;
  final buttonOffset = 150 / 2;

  @override
  Widget build(BuildContext context) {
    var playerButtons = <Widget>[];

    var round = widget.game.rounds[widget.game.currentRound - 1];

    for (int i = 0; i < widget.game.players.length; i++) {
      var player = widget.game.players[i];
      var angle = 360 / widget.game.players.length * i * -1 + 180;

      var x = radius * sin(pi * 2 * angle / 360) +
          MediaQuery.of(context).size.width / 2 -
          buttonOffset;
      var y = radius * cos(pi * 2 * angle / 360) +
          MediaQuery.of(context).size.height / 2 -
          buttonOffset;

      playerButtons.add(
        Transform.translate(
          offset: Offset(x, y),
          child: PlayerButton(
            playerIndex: i,
            player: player,
            round: round,
            game: widget.game,
            onTab: () {
              var game = widget.game;
              round.results[round.currentTrick] = i;

              if (round.currentTrick + 1 == widget.game.currentRound) {
                if (game.currentRound == game.getMaxRounds()) {
                  game.saveGame();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameFinishedScreen(
                        game: game,
                      ),
                    ),
                    (_) => false,
                  );
                  return;
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewSectionScreen(
                      initCallback: () {
                        widget.game.newRound();
                      },
                      color: Theme.of(context).colorScheme.primary,
                      title: 'Round',
                      current: widget.game.currentRound + 1,
                      max: widget.game.getMaxRounds(),
                      navigateCallback: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectPrediction(
                              game: widget.game,
                              index: widget.game.getCurrentFirstPredictor(),
                            ),
                          ),
                          (_) => false,
                        );
                      },
                      duration: const Duration(seconds: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CurrentDealerWidget(
                            dealerName: game.players[
                                game.getBoundedIndex((game.dealer ?? 0) + 1)],
                          ),
                          ScoreboardWidget(
                            game: widget.game,
                          ),
                        ],
                      ),
                    ),
                  ),
                  (_) => false,
                );

                return;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => NewSectionScreen(
                    initCallback: () {
                      round.currentTrick++;
                    },
                    color: Theme.of(context).colorScheme.tertiary,
                    title: 'Trick',
                    current: round.currentTrick + 2,
                    max: widget.game.currentRound,
                    navigateCallback: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrickSelector(
                            game: widget.game,
                          ),
                        ),
                        (_) => false,
                      );
                    },
                  ),
                ),
                (_) => false,
              );
            },
          ),
        ),
      );
    }

    return PopScope(
      onPopInvoked: (_) {
        // determine back origin (new round or new trick)
        if (round.currentTrick == 0) {
          // new round
          widget.game.currentRound--;
          widget.game.rounds.removeLast();
        } else {
          // new trick
          round.currentTrick--;
        }
      },
      child: Scaffold(
        appBar: getAppBar(context, true, widget.game),
        backgroundColor: getAppBarBackgroundColor(context),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: Theme.of(context).colorScheme.background,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      '${widget.game.currentRound}. Round',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.game.rounds[widget.game.currentRound - 1].currentTrick + 1}/${widget.game.currentRound} Trick',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints.expand(),
              child: Stack(
                children: playerButtons,
              ),
            )
          ],
        ),
      ),
    );
  }
}
