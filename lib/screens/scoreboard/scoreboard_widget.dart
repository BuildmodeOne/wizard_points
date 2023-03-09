import 'package:flutter/material.dart';

import '../../services/models.dart';

class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    var scores = game.getScores();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: scores.length,
        itemBuilder: (context, index) {
          var player = scores.keys.elementAt(index);

          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(player.name),
              trailing: Text("${scores[player]} points"),
            ),
          );
        },
      ),
    );
  }
}
