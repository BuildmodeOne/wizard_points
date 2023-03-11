import 'package:flutter/material.dart';

class AddPlayerDialog extends StatelessWidget {
  const AddPlayerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    void changeName(String value) {
      Navigator.of(context).pop(value);
    }

    return AlertDialog(
      title: const Text('Add Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Player Name',
            ),
            onSubmitted: (value) => changeName(value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            changeName(nameController.text);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
