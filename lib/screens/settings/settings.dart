import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wizard_points/screens/settings/legal/license_page.dart';
import 'package:wizard_points/shared/appbar.dart';

import '../../services/config.dart';
import '../../services/models.dart';

class SettingsScreen extends StatefulWidget {
  final GameSettings settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

Future<void> launch(String url, {bool isNewTab = true}) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
  );
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var settings = widget.settings;

    var storage = LocalStorage('wizard_points');

    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: getTitleAppBar(context, 'Settings'),
            backgroundColor: getAppBarBackgroundColor(context),
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                        right: 12,
                        bottom: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SettingsGroup(
                            title: 'Personalization',
                            children: [
                              SettingsSwitch(
                                title: 'Dark Mode',
                                value: themeNotifier.isDark,
                                onChanged: (value) async {
                                  themeNotifier.setTheme(value);

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('theme', themeNotifier.isDark);
                                },
                                icon: Icons.color_lens_rounded,
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.all(6.0),
                          ),

                          // GAME SETTINGS
                          SettingsGroup(
                            title: 'Game Settings',
                            children: [
                              // reward only if correct
                              SettingsSwitch(
                                title: 'Always reward tricks',
                                description:
                                    'Players always get points for the number of tricks, even if they predicted them wrong',
                                value: settings.alwaysRewardTricks,
                                onChanged: (value) {
                                  settings.alwaysRewardTricks = value;
                                  storage.setItem(
                                      'settings', settings.toJson());

                                  setState(() {});
                                },
                                icon: FluentIcons.lightbulb_person_20_filled,
                              ),

                              // reward if player gets all tricks
                              IgnorePointer(
                                ignoring: settings.alwaysRewardTricks,
                                child: AnimatedOpacity(
                                  opacity:
                                      !settings.alwaysRewardTricks ? 1 : 0.3,
                                  duration: const Duration(milliseconds: 250),
                                  child: SettingsSwitch(
                                    title:
                                        'Reward for all tricks despite wrong prediction',
                                    description:
                                        'If a player wins all tricks in a round despite a wrong prediction, the tricks are rewarded. This is only available with more than 1 card.',
                                    value: settings
                                            .rewardAllTricksDespitePrediction &&
                                        !settings.alwaysRewardTricks,
                                    onChanged: (value) {
                                      settings.rewardAllTricksDespitePrediction =
                                          value;
                                      storage.setItem(
                                          'settings', settings.toJson());

                                      setState(() {});
                                    },
                                    icon: FluentIcons.reward_20_filled,
                                  ),
                                ),
                              ),

                              // plus minus one
                              SettingsSwitch(
                                title: 'Plus/minus one',
                                description:
                                    'The sum of predictions must not add up to the amount of cards, but can be less or more',
                                value: settings.plusMinusOneVariant,
                                onChanged: (value) {
                                  settings.plusMinusOneVariant = value;
                                  storage.setItem(
                                      'settings', settings.toJson());

                                  setState(() {});
                                },
                                icon: FluentIcons.clipboard_20_filled,
                              ),

                              // always allow 0 predictions for last player even if the sum == currentRound
                              IgnorePointer(
                                ignoring: !settings.plusMinusOneVariant,
                                child: AnimatedOpacity(
                                  opacity:
                                      settings.plusMinusOneVariant ? 1 : 0.3,
                                  duration: const Duration(milliseconds: 250),
                                  child: SettingsSwitch(
                                    title: 'Allow zero prediction',
                                    description:
                                        'Zero predictions allowed for last player, even if the predictions sum up to the amount of cards',
                                    value: settings.allowZeroPrediction &&
                                        settings.plusMinusOneVariant,
                                    onChanged: (value) {
                                      settings.allowZeroPrediction = value;
                                      storage.setItem(
                                          'settings', settings.toJson());

                                      setState(() {});
                                    },
                                    icon: FluentIcons.clipboard_error_20_filled,
                                  ),
                                ),
                              ),

                              // points for correct prediction
                              SettingsNumberForm(
                                title: 'Correct prediction',
                                description:
                                    'Points for the correct prediction of tricks',
                                initialValue: settings
                                    .pointsForCorrectPrediction
                                    .toString(),
                                icon: FluentIcons.predictions_20_filled,
                                onChanged: (value) {
                                  try {
                                    settings.pointsForCorrectPrediction =
                                        int.parse(value);

                                    storage.setItem(
                                        'settings', settings.toJson());
                                    // ignore: empty_catches
                                  } catch (e) {}
                                },
                              ),

                              // points for tricks
                              SettingsNumberForm(
                                title: 'Tricks',
                                description: 'Points for each trick',
                                initialValue:
                                    settings.pointsForTricks.toString(),
                                icon: FluentIcons.sparkle_20_filled,
                                onChanged: (value) {
                                  try {
                                    settings.pointsForTricks = int.parse(value);
                                    storage.setItem(
                                        'settings', settings.toJson());

                                    // ignore: empty_catches
                                  } catch (e) {}
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  launch('/assets/legal/imprint.html');
                                },
                                child: const Text('Imprint'),
                              ),
                              const Text(' | '),
                              TextButton(
                                onPressed: () {
                                  launch('/assets/legal/privacy.html');
                                },
                                child: const Text('Privacy Policy'),
                              ),
                              const Text(' | '),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomLicensePage(),
                                    ),
                                  );
                                },
                                child: const Text('Licenses'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsHeader(
          title: title,
        ),
        Wrap(
          runSpacing: 16,
          children: children,
        )
      ],
    );
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsElement extends StatelessWidget {
  const SettingsElement({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    required this.child,
  });

  final String title;
  final String? description;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var headerSize = 16.0;
    var explainSize = 12.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 12.0, bottom: 4.0),
          child: Icon(icon),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: headerSize,
                ),
              ),
              Visibility(
                visible: description != null,
                child: Text(
                  description ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: explainSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
        ),
        child,
      ],
    );
  }
}

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  final String title;
  final String? description;
  final bool value;
  final IconData icon;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsElement(
      title: title,
      description: description,
      icon: icon,
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class SettingsNumberForm extends StatelessWidget {
  const SettingsNumberForm({
    super.key,
    required this.title,
    this.description,
    required this.initialValue,
    required this.icon,
    required this.onChanged,
  });

  final String title;
  final String? description;
  final String initialValue;
  final IconData icon;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsElement(
      title: title,
      icon: icon,
      description: description,
      child: SizedBox(
        width: 50,
        child: TextFormField(
          textAlign: TextAlign.center,
          autocorrect: false,
          initialValue: initialValue,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
