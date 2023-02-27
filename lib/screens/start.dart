import 'package:flutter/material.dart';

import '../shared/appbar.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Wizard Points"),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
