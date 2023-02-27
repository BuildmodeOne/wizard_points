import 'dart:async';

import 'package:flutter/material.dart';

class NewSectionScreen extends StatefulWidget {
  final VoidCallback initCallback;
  final VoidCallback navigateCallback;
  final String title;
  final int current;
  final int max;
  final Color color;

  const NewSectionScreen(
      {super.key,
      required this.navigateCallback,
      required this.title,
      required this.current,
      required this.max,
      required this.color,
      required this.initCallback});

  @override
  State<NewSectionScreen> createState() => _NewSectionScreenState();
}

class _NewSectionScreenState extends State<NewSectionScreen>
    with TickerProviderStateMixin {
  final Duration duration = const Duration(seconds: 5);
  // final Duration duration = const Duration(milliseconds: 1);

  late AnimationController controller;
  late Timer t;

  @override
  void initState() {
    widget.initCallback.call();

    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: duration,
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();

    t = Timer(duration, () {
      widget.navigateCallback.call();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = 300.0;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                "New ${widget.title}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(45),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: SizedBox(
                          height: size,
                          width: size,
                          child: CircularProgressIndicator(
                            color: widget.color,
                            value: controller.value,
                            strokeWidth: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              // "${widget.game.currentRound} / ${widget.game.getMaxRounds()}",
                              "${widget.current} / ${widget.max}",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.title,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  t.cancel();
                  widget.navigateCallback.call();
                },
                icon: const Icon(Icons.skip_next_rounded),
                label: const Text("Skip"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
