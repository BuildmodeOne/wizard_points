import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../services/models.dart';

class EditPlayerDialog extends StatelessWidget {
  final String player;
  final Game game;
  const EditPlayerDialog({required this.player, super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController()
      ..value = TextEditingValue(text: player);

    void changeName(String value) {
      Navigator.of(context).pop(value);
    }

    return AlertDialog(
      title: const Text('Edit Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Player Name',
            ),
            onSubmitted: (value) => changeName(value),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
          Visibility(
            visible: !game.isRunning(),
            child: TextButton.icon(
              onPressed: () {
                game.dealer = game.players.indexOf(player);
                Navigator.pop(context, nameController.text);
              },
              icon: const Icon(FluentIcons.board_games_20_filled),
              label: const Text('Dealer'),
            ),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: !game.isRunning(),
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            changeName(nameController.text);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
