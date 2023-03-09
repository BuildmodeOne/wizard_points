import 'package:flutter/material.dart';

import '../../services/models.dart';

class EditPlayerDialog extends StatelessWidget {
  final Player player;
  final Game game;
  const EditPlayerDialog({required this.player, super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController()
      ..value = TextEditingValue(text: player.name);

    void changeName(String value) {
      Navigator.of(context).pop(value);
    }

    return AlertDialog(
      title: const Text("Edit Player"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Player Name",
            ),
            onSubmitted: (value) => changeName(value),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
          TextButton.icon(
            onPressed: () {
              game.dealer = player;
              Navigator.pop(context, nameController.text);
            },
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text("Dealer"),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
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
