import 'package:flutter/material.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard_widget.dart';
import 'package:wizard_points/shared/appbar.dart';

import '../../services/models.dart';

class Scoreboard extends StatefulWidget {
  final Game game;
  const Scoreboard({super.key, required this.game});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    void update() {
      setState(() {});
    }

    return Scaffold(
      appBar: getTitleAppBar(context, 'Scoreboard'),
      backgroundColor: getAppBarBackgroundColor(context),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: ScoreboardWidget(
                game: widget.game,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
