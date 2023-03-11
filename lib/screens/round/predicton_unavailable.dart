import 'package:flutter/material.dart';

class PredictionNotAllowed extends StatelessWidget {
  final int prediction;

  const PredictionNotAllowed({required this.prediction, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("You can't choose $prediction as your prediction."),
          const Text(
              'The number of predictions must not sum up to the number of cards to avoid that everybody is correct.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
