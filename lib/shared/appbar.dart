import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizard_points/screens/scoreboard/scoreboard.dart';

import '../services/config.dart';
import '../services/models.dart';

AppBar getAppBar(BuildContext context, String text,
    [bool backButton = true, bool showScoreboard = false, Game? game]) {
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
                builder: (context) => Scoreboard(game: game!),
              ),
            );
          },
          icon: const Icon(Icons.poll_rounded),
        ),
      ),
      IconButton(
          onPressed: () async {
            themeNotifier.toggleTheme();

            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('theme', themeNotifier.isDark);
          },
          icon: themeNotifier.isDark
              ? const Icon(Icons.brightness_high)
              : const Icon(Icons.brightness_low)),
      const Padding(padding: EdgeInsets.all(10)),
    ],
  );
}
