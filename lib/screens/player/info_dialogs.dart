import 'package:flutter/material.dart';

class NotEnoughPlayers extends StatelessWidget {
  const NotEnoughPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Info"),
      content:
          const Text("At least three players are required to start a game."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
