import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, required this.max});
  final int value;
  final int max;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      label: 'Progression',
      value: '$value sur $max',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LinearProgressIndicator(
          value: max == 0 ? 0 : value / max,
          minHeight: 6,
          backgroundColor: t.line,
          color: t.ink,
        ),
      ),
    );
  }
}
