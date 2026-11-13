import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class ChipButton extends StatelessWidget {
  const ChipButton({super.key, required this.label, required this.onPressed, this.current = false});
  final String label;
  final VoidCallback onPressed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      button: true,
      selected: current,
      child: Material(
        color: current ? t.ink : t.surface,
        shape: StadiumBorder(side: BorderSide(color: current ? t.ink : t.line)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(label, style: bodyStyle(current ? t.surface : t.ink, 14.4)),
          ),
        ),
      ),
    );
  }
}
