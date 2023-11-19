import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:wizard_points/services/models.dart';
import 'package:wizard_points/shared/shifted_icon.dart';

class DealerCard extends StatelessWidget {
  final Game game;
  const DealerCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const ShiftedIcon(icon: FluentIcons.board_games_20_filled),
        title: Text(game.players[game.dealer ?? 0]),
        subtitle: const Text('Dealer'),
      ),
    );
  }
}
