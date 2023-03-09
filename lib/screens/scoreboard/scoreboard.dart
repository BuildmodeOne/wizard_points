import 'package:flutter/material.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard_widget.dart';
import 'package:wizard_points/shared/appbar.dart';

import '../../services/models.dart';

class Scoreboard extends StatelessWidget {
  final Game game;
  const Scoreboard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Scoreboard"),
      body: ScoreboardWidget(
        game: game,
      ),
    );
  }
}
