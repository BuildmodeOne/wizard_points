import 'package:flutter/material.dart';

import '../../../services/models.dart';

class PlayerButton extends StatelessWidget {
  final String player;
  final int playerIndex;
  final Round round;
  final VoidCallback onTab;
  final Game game;
  const PlayerButton(
      {required this.player,
      required this.round,
      required this.onTab,
      super.key,
      required this.playerIndex,
      required this.game});

  final size = 120.0;

  @override
  Widget build(BuildContext context) {
    var startPlayer = (round.currentTrick == 0 &&
            game.getCurrentFirstPredictor() == playerIndex) ||
        (round.currentTrick > 0 &&
            round.results[round.currentTrick - 1] == playerIndex);

    return InkWell(
      onTap: onTab,
      borderRadius: BorderRadius.circular(size / 2),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: startPlayer
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.tertiaryContainer,
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                Text(
                  player,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ('${round.getResultsCount(playerIndex)}/${round.predictions[playerIndex] ?? 0}'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' predicted'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
