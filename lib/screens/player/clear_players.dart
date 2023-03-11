import 'package:flutter/material.dart';

class ClearPlayersDialog extends StatelessWidget {
  const ClearPlayersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clear Players'),
      content: const Text('Do you want to clear all players from the game?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
