import 'package:flutter/material.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard.dart';
import 'package:wizard_points/screens/settings/settings.dart';
import 'package:wizard_points/services/config.dart';

import '../services/models.dart';

List<Widget> getAppBarActions(BuildContext context, bool showScoreboard,
    Game? game, VoidCallback? action) {
  return [
    Visibility(
      visible: showScoreboard,
      child: IconButton(
        onPressed: () => game!.restartGame(game, context),
        icon: const Icon(Icons.restart_alt_rounded),
      ),
    ),
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
  ];
}

Color getAppBarForegroundColor(BuildContext context) {
  return themeNotifier.isDark
      ? Theme.of(context).colorScheme.onPrimaryContainer
      : Theme.of(context).colorScheme.onPrimary;
}

Color getAppBarBackgroundColor(BuildContext context) {
  return themeNotifier.isDark
      ? Theme.of(context).colorScheme.primaryContainer
      : Theme.of(context).colorScheme.primary;
}

AppBar getAppBar(BuildContext context, bool showScoreboard, Game? game,
    [VoidCallback? action, bool backButton = true]) {
  return AppBar(
    clipBehavior: Clip.none,
    backgroundColor: getAppBarBackgroundColor(context),
    foregroundColor: getAppBarForegroundColor(context),
    automaticallyImplyLeading: backButton,
    title: const Text('Wizard Points'),
    actions: getAppBarActions(context, showScoreboard, game, action),
  );
}
