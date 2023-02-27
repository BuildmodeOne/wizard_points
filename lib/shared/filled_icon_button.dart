import 'package:flutter/material.dart';

class FilledIconButton extends StatelessWidget {
  const FilledIconButton(
      {required this.onPressed, required this.icon, super.key});
  final VoidCallback onPressed;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        foregroundColor: colors.onTertiaryContainer,
        backgroundColor: colors.tertiaryContainer,
        disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
        hoverColor: colors.onTertiaryContainer.withOpacity(0.08),
        focusColor: colors.onTertiaryContainer.withOpacity(0.12),
        highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
      ),
    );
  }
}
