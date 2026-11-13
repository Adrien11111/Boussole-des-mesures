import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class CardSurface extends StatelessWidget {
  const CardSurface({super.key, required this.child, this.padding = 20});
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
