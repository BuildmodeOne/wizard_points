import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:wizard_points/services/models.dart';
import 'package:wizard_points/shared/shifted_icon.dart';

class CardsCard extends StatelessWidget {
  final Game game;
  const CardsCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const ShiftedIcon(icon: FluentIcons.copy_24_filled),
        title: Text('${game.currentRound} Cards'),
        subtitle: const Text('per Player'),
      ),
    );
  }
}
