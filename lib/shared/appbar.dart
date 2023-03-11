import 'package:flutter/material.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard.dart';
import 'package:wizard_points/screens/settings/settings.dart';

import '../services/config.dart';
import '../services/models.dart';

AppBar getAppBar(BuildContext context, String text, bool backButton,
    bool showScoreboard, Game? game,
    [VoidCallback? action]) {
  return AppBar(
    automaticallyImplyLeading: backButton,
    backgroundColor: themeNotifier.isDark
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.primary,
    foregroundColor: themeNotifier.isDark
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onPrimary,
    elevation: 5,
    title: Text(text),
    actions: [
      Visibility(
        visible: showScoreboard,
        child: IconButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scoreboard(game: game!),
              ),
            );
          },
          icon: const Icon(Icons.poll_rounded),
        ),
      ),
      IconButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettingsScreen(settings: game!.settings),
            ),
          ).then((value) {
            if (action != null) {
              action();
            }
          });
        },
        icon: const Icon(Icons.settings),
      ),
      const Padding(padding: EdgeInsets.all(10)),
    ],
  );
}
