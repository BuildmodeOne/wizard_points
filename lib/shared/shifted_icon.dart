import 'package:flutter/material.dart';

class ShiftedIcon extends StatelessWidget {
  final IconData icon;
  const ShiftedIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -2),
      child: Icon(icon),
    );
  }
}
