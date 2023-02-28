import 'package:flutter/material.dart';
import 'package:wizard_points/shared/appbar.dart';

import '../../services/models.dart';

class Scoreboard extends StatelessWidget {
  final Game game;
  const Scoreboard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    var scores = game.getScores();

    return Scaffold(
      appBar: getAppBar(context, "Scoreboard"),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
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
          )),
    );
  }
}
