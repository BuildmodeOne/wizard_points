import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wizard_points/screens/player/players_screen.dart';
import 'package:wizard_points/screens/round/predicton_unavailable.dart';
import 'package:wizard_points/screens/round/trick_selector.dart';
import 'package:wizard_points/shared/appbar.dart';
import 'package:wizard_points/shared/filled_icon_button.dart';

import '../../services/models.dart';
import '../../services/scroll_behaviour.dart';

class SelectPrediction extends StatefulWidget {
  final Game game;
  final int index;

  const SelectPrediction({required this.game, required this.index, super.key});

  @override
  State<SelectPrediction> createState() => _SelectPredictionState();
}

class _SelectPredictionState extends State<SelectPrediction> {
  @override
  Widget build(BuildContext context) {
    var round = widget.game.rounds[widget.game.currentRound - 1];
    var player = widget.game.players[widget.index];

    int currentValue = round.predictions[player] ?? 0;
    bool isLast = widget.index == widget.game.players.length - 1;

    int predSum = round.predictions.values.fold(0, (a, b) => a + b);

    void setPrediction(int value) {
      if (value > widget.game.currentRound) {
        return;
      }

      if (value < 0) {
        return;
      }

      round.predictions[player] = value;

      setState(() {
        currentValue = value;
      });
    }

    return Scaffold(
      appBar: getAppBar(context, "Predict tricks", false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (isLast && predSum == widget.game.currentRound) {
            await showDialog(
              context: context,
              builder: (context) =>
                  PredictionNotAllowed(prediction: currentValue),
            );

            return;
          }

          if (isLast) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TrickSelector(
                  game: widget.game,
                ),
              ),
              (_) => false,
            );
            return;
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SelectPrediction(
                game: widget.game,
                index: widget.index + 1,
              ),
            ),
            (_) => false,
          );
        },
        label: const Text("Predict"),
        icon: const Icon(Icons.check_rounded),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            const Text(
              "Predict your tricks,",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              player.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledIconButton(
                        onPressed: () {
                          setPrediction(currentValue - 1);
                        },
                        icon: const Icon(Icons.remove_rounded),
                      ),
                      ScrollConfiguration(
                        behavior:
                            MobileScrollBehaviour().copyWith(scrollbars: false),
                        child: NumberPicker(
                          minValue: 0,
                          maxValue: widget.game.currentRound,
                          haptics: true,
                          onChanged: (value) {
                            setPrediction(value);
                          },
                          value: currentValue,
                        ),
                      ),
                      FilledIconButton(
                        onPressed: () {
                          setPrediction(currentValue + 1);
                        },
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity:
                        isLast && predSum == widget.game.currentRound ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                            Text(
                              "This prediction is not allowed",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
          ],
        ),
      ),
    );
  }
}
