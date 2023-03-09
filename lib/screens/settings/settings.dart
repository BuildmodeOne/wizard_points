import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: themeNotifier.isDark
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.primary,
        foregroundColor: themeNotifier.isDark
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onPrimary,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Personalization",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.color_lens_rounded),
                ),
                const Expanded(
                  child: Text("Dark Mode",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
                Switch(
                  value: themeNotifier.isDark,
                  onChanged: (value) {
                    themeNotifier.setTheme(value);
                  },
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Game Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
