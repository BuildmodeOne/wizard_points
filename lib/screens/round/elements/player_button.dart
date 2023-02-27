import 'package:flutter/material.dart';

import '../../../services/models.dart';

class PlayerButton extends StatelessWidget {
  final Player player;
  final Round round;
  final VoidCallback onTab;
  const PlayerButton(
      {required this.player,
      required this.round,
      required this.onTab,
      super.key});

  final size = 120.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      borderRadius: BorderRadius.circular(size / 2),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: Theme.of(context).colorScheme.tertiaryContainer,
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
                  player.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (round.predictions[player] ?? 0).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(" predicted"),
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
