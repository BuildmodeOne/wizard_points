import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
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
  late Game game;
  late int index;

  @override
  void initState() {
    super.initState();
    game = widget.game;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    var round = game.rounds[game.currentRound - 1];
    var predictions = round.predictions;
    var player = game.players[index];

    int currentValue = predictions[index] ?? 0;
    bool isLast = index == game.players.length - 1;

    int predSum = round.predictions.values.fold(0, (a, b) => a + b);

    void setPrediction(int value) {
      if (value > game.currentRound) {
        return;
      }

      if (value < 0) {
        return;
      }

      setState(() {
        predictions[index] = value;
      });
    }

    return Scaffold(
      appBar: getAppBar(context, "Predict tricks", false, true, game),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (isLast && predSum == game.currentRound) {
            await showDialog(
              context: context,
              builder: (context) => PredictionNotAllowed(
                prediction: currentValue,
              ),
            );

            return;
          }

          if (isLast) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TrickSelector(
                  game: game,
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
                game: game,
                index: index + 1,
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
                          maxValue: game.currentRound,
                          haptics: false,
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
                    opacity: isLast && predSum == game.currentRound ? 1 : 0,
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
            Text(
              "Dealer: ${game.players[game.dealer ?? 0].name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${game.currentRound}. Round",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(25.0),
            ),
          ],
        ),
      ),
    );
  }
}
