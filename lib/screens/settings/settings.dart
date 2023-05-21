import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/config.dart';
import '../../services/models.dart';

class SettingsScreen extends StatefulWidget {
  final GameSettings settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var headerSize = 16.0;
    var explainSize = 12.0;

    var settings = widget.settings;

    var storage = LocalStorage('wizard_points');

    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: themeNotifier.isDark
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.primary,
              foregroundColor: themeNotifier.isDark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onPrimary,
              elevation: 5,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PERSONALISATION SETTINGS
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Personalization',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.color_lens_rounded),
                      ),
                      Expanded(
                        child: Text('Dark Mode',
                            style: TextStyle(
                              fontSize: headerSize,
                            )),
                      ),
                      Switch(
                        value: themeNotifier.isDark,
                        onChanged: (value) async {
                          themeNotifier.setTheme(value);

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('theme', themeNotifier.isDark);
                        },
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                  ),

                  // GAME SETTINGS
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Game Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // reward only if correct
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                        child: Icon(FluentIcons.lightbulb_person_20_filled),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Always reward tricks',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Players always get points for the number of tricks, even if they predicted them wrong',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: explainSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                      ),
                      Switch(
                        value: settings.alwaysRewardTricks,
                        onChanged: (value) {
                          settings.alwaysRewardTricks = value;
                          storage.setItem('settings', settings.toJson());

                          setState(() {});
                        },
                      )
                    ],
                  ),

                  // reward if player gets all tricks
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  IgnorePointer(
                    ignoring: settings.alwaysRewardTricks,
                    child: AnimatedOpacity(
                      opacity: !settings.alwaysRewardTricks ? 1 : 0.3,
                      duration: const Duration(milliseconds: 250),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 4.0),
                            child: Icon(FluentIcons.reward_20_filled),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Reward for all tricks despite wrong prediction',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'If a player wins all tricks in a round despite a wrong prediction, the tricks are rewarded. This is only available with more than 1 card.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: explainSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                          ),
                          Switch(
                            value: settings.rewardAllTricksDespitePrediction &&
                                !settings.alwaysRewardTricks,
                            onChanged: (value) {
                              settings.rewardAllTricksDespitePrediction = value;
                              storage.setItem('settings', settings.toJson());

                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  // plus minus one
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                        child: Icon(FluentIcons.clipboard_20_filled),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Plus/minus one',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'The sum of predictions must not add up to the amount of cards, but can be less or more',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: explainSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                      ),
                      Switch(
                        value: settings.plusMinusOneVariant,
                        onChanged: (value) {
                          settings.plusMinusOneVariant = value;
                          storage.setItem('settings', settings.toJson());

                          setState(() {});
                        },
                      )
                    ],
                  ),

                  // always allow 0 predictions for last player even if the sum == currentRound
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  IgnorePointer(
                    ignoring: !settings.plusMinusOneVariant,
                    child: AnimatedOpacity(
                      opacity: settings.plusMinusOneVariant ? 1 : 0.3,
                      duration: const Duration(milliseconds: 250),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 4.0),
                            child: Icon(FluentIcons.clipboard_error_20_filled),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Allow zero prediciton',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Zero predictions allowed for last player, even if the predictions sum up to the amount of cards',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: explainSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                          ),
                          Switch(
                            value: settings.allowZeroPrediction &&
                                settings.plusMinusOneVariant,
                            onChanged: (value) {
                              settings.allowZeroPrediction = value;
                              storage.setItem('settings', settings.toJson());

                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  // points for correct prediction
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                        child: Icon(FluentIcons.predictions_20_filled),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Correct prediction',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Points for the correct prediction of tricks',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: explainSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          autocorrect: false,
                          initialValue:
                              settings.pointsForCorrectPrediction.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            try {
                              settings.pointsForCorrectPrediction =
                                  int.parse(value);

                              storage.setItem('settings', settings.toJson());
                              // ignore: empty_catches
                            } catch (e) {}
                          },
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  // points for tricks
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                        child: Icon(FluentIcons.sparkle_20_filled),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tricks',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Points for each trick',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: explainSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          autocorrect: false,
                          initialValue: settings.pointsForTricks.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            try {
                              settings.pointsForTricks = int.parse(value);
                              storage.setItem('settings', settings.toJson());

                              // ignore: empty_catches
                            } catch (e) {}
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Center(
          child: Text('Error'),
        );
      },
    );
  }
}
