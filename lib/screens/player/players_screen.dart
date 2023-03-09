import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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

    void onReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Player item = game.players.removeAt(oldIndex);
      game.players.insert(newIndex, item);
    }

    Future editNameDialog(Player player) {
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
        if (result is String && result != "") {
          game.players[index].name = result;
        }

        if (result is bool && result == true) {
          game.players.removeAt(index);
        }
      });
    }

    Future<void> addPlayer() async {
      var result = await addNameDialog();
      setState(() {
        if (result is String && result != "") {
          game.players.add(Player(name: result));

          if (game.players.length == 1) {
            game.dealer = game.players[0];
          }
        }
      });
    }

    void startGame() {
      if (game.players.length < 3) {
        showDialog(
          context: context,
          builder: (context) => const NotEnoughPlayers(),
        );

        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewSectionScreen(
            initCallback: () {
              game.newRound();
            },
            color: Theme.of(context).colorScheme.primary,
            title: "Round",
            current: game.currentRound + 1,
            max: game.getMaxRounds(),
            navigateCallback: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPrediction(
                      game: game,
                      index: 0,
                    ),
                  ),
                  (_) => false);
            },
            duration: const Duration(seconds: 3),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: getAppBar(context, "Add Players"),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: game.players.length < 6,
            child: FloatingActionButton.extended(
              onPressed: () => addPlayer(),
              heroTag: "btn1",
              label: const Text("Player"),
              icon: const Icon(Icons.add_rounded),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          const Padding(padding: EdgeInsets.all(4.0)),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () => startGame(),
            label: const Text("Start Game"),
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableListView.builder(
            itemBuilder: (context, index) => Card(
                  key: ValueKey(index),
                  child: ListTile(
                    title: Text(game.players[index].name),
                    trailing: Visibility(
                      visible: game.players[index] == game.dealer,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Chip(
                            elevation: 0,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            avatar: Icon(
                              Icons.ios_share_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            label: const Text("Dealer"),
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(100),
                            )
                            // padding: EdgeInsets.all(1),
                            ),
                      ),
                    ),
                    subtitle: Text("${index + 1}. Player"),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      editPlayer(index);
                    },
                  ),
                ),
            itemCount: game.players.length,
            onReorder: onReorder),
      ),
    );
  }
}
