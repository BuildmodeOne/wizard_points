import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum RestartDialogResult { delete, keepPlayers, cancel }

class RestartGameDialog extends StatefulWidget {
  const RestartGameDialog({super.key});

  @override
  State<RestartGameDialog> createState() => _RestartGameDialogState();
}

class _RestartGameDialogState extends State<RestartGameDialog> {
  late bool keepPlayers;

  @override
  void initState() {
    super.initState();

    keepPlayers = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Restart Game'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you sure you want to restart the game?'),
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0, bottom: 4.0),
                child: Icon(FluentIcons.person_24_filled),
              ),
              const Expanded(
                child: Text(
                  'Keep players',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
              ),
              Switch(
                value: keepPlayers,
                onChanged: (value) {
                  setState(() {
                    keepPlayers = value;
                  });
                },
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(RestartDialogResult.cancel);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(keepPlayers
                ? RestartDialogResult.keepPlayers
                : RestartDialogResult.delete);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
