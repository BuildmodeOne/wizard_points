import 'package:flutter/material.dart';

class PredictButtonCard extends StatelessWidget {
  final VoidCallback onPressed;
  const PredictButtonCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
        child: const ListTile(
          leading: Icon(Icons.check_rounded),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('Predict'),
          ),
        ),
      ),
    );
  }
}
