import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:wizard_points/screens/player/clear_players.dart';
import 'package:wizard_points/screens/player/edit_player_dialog.dart';
import 'package:wizard_points/screens/player/info_dialogs.dart';
import 'package:wizard_points/screens/rounds/new_section_screen.dart';
import 'package:wizard_points/services/models.dart';

import '../../shared/appbar.dart';
import '../round/select_prediction.dart';
import 'add_player_dialog.dart';

class PlayerCreationScreen extends StatefulWidget {
  const PlayerCreationScreen({super.key, required this.game});

  final Game game;

  @override
  State<PlayerCreationScreen> createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  @override
  Widget build(BuildContext context) {
    var game = widget.game;
    var isRunning =
        game.currentRound > 0 && game.currentRound < game.getMaxRounds();

    void onReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      var dealer = game.players[game.dealer!];

      final String item = game.players.removeAt(oldIndex);
      game.players.insert(newIndex, item);

      game.dealer = game.players.indexOf(dealer);
    }

    Future editNameDialog(String player) {
      return showDialog(
        context: context,
        builder: (context) => EditPlayerDialog(player: player, game: game),
      );
    }

    Future addNameDialog() {
      return showDialog(
        context: context,
        builder: (context) => const AddPlayerDialog(),
      );
    }

    Future<void> editPlayer(int index) async {
      var result = await editNameDialog(game.players[index]);
      setState(() {
        if (result is String && result != '') {
          game.players[index] = result;
        }

        if (result is bool && result == true) {
          game.players.removeAt(index);
        }
      });
    }

    Future<void> addPlayer() async {
      var result = await addNameDialog();
      setState(() {
        if (result is String && result != '') {
          game.players.add(result);

          if (game.players.length == 1) {
            game.dealer = 0;
          }
        }
      });
    }

    clearPlayers() async {
      var result = await showDialog(
        context: context,
        builder: (context) => const ClearPlayersDialog(),
      );

      if (result != true) {
        return;
      }

      setState(() {
        game.players.clear();
      });
    }

    void nextRound() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NewSectionScreen(
            initCallback: () {
              game.newRound();
            },
            color: Theme.of(context).colorScheme.primary,
            title: 'Round',
            current: game.currentRound + 1,
            max: game.getMaxRounds(),
            navigateCallback: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectPrediction(
                    game: game,
                    index: game.getCurrentFirstPredictor(),
                  ),
                ),
                (_) => false,
              );
            },
            duration: const Duration(seconds: 3),
          ),
        ),
        (_) => false,
      );
    }

    Future<void> startGame() async {
      if (game.players.length < 3) {
        showDialog(
          context: context,
          builder: (context) => const NotEnoughPlayers(),
        );

        return;
      }

      var storage = LocalStorage('wizard_points');
      await storage.ready;

      await storage.setItem('game', game.toJson());

      nextRound();
    }

    return Scaffold(
      appBar: getAppBar(context, isRunning, game),
      backgroundColor: getAppBarBackgroundColor(context),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: game.players.length < 6,
            child: FloatingActionButton.extended(
              onPressed: () => addPlayer(),
              heroTag: 'btn1',
              label: const Text('Player'),
              icon: const Icon(Icons.add_rounded),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          const Padding(padding: EdgeInsets.all(4.0)),
          Visibility(
            visible: !isRunning,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: game.players.isNotEmpty,
                  child: FloatingActionButton(
                    onPressed: () => clearPlayers(),
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    child: const Icon(Icons.delete_rounded),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(2),
                ),
                FloatingActionButton.extended(
                  heroTag: 'btn2',
                  onPressed: () => startGame(),
                  label: const Text('Start Game'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          Visibility(
            visible: isRunning,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FloatingActionButton(
                //   onPressed: () => game.restartGame(game, context),
                //   backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                //   foregroundColor:
                //       Theme.of(context).colorScheme.onSurfaceVariant,
                //   child: const Icon(Icons.restart_alt_rounded),
                // ),
                // const Padding(
                //   padding: EdgeInsets.all(2),
                // ),
                FloatingActionButton.extended(
                  heroTag: 'btn2',
                  onPressed: () => startGame(),
                  label: const Text('Resume Game'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                visible: isRunning,
                child: Column(
                  children: [
                    const Text(
                      'Running Game',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${game.currentRound}. Round',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !isRunning && game.players.isEmpty,
                child: Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.people_team_20_regular,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Text(
                          'Add at least 3 players to start a game.',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ReorderableListView.builder(
                buildDefaultDragHandles: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(index),
                  child: ListTile(
                    title: Text(game.players[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: index == game.dealer,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Chip(
                                elevation: 0,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                avatar: Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Icon(
                                    FluentIcons.board_games_20_filled,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                                label: const Text('Dealer'),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(100),
                                )
                                // padding: EdgeInsets.all(1),
                                ),
                          ),
                        ),
                        Visibility(
                          visible: !isRunning,
                          child: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_indicator_outlined),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('${index + 1}. Player'),
                    ),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      editPlayer(index);
                    },
                  ),
                ),
                itemCount: game.players.length,
                onReorder: onReorder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
