import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class Heading extends StatelessWidget {
  const Heading(this.text, {super.key, this.level = 2});
  final String text;
  final int level;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      header: true,
      child: Text(text,
          style: switch (level) {
            1 => displayStyle(t.ink, MediaQuery.sizeOf(context).width < 520 ? 34 : 48, height: 1.05),
            2 => displayStyle(t.ink, 21.6, weight: 650, height: 1.2),
            _ => displayStyle(t.ink, 16.8, weight: 650, height: 1.2),
          }),
    );
  }
}

class MutedText extends StatelessWidget {
  const MutedText(this.text, {super.key, this.small = false, this.center = false});
  final String text;
  final bool small;
  final bool center;

  @override
  Widget build(BuildContext context) => Text(text,
      textAlign: center ? TextAlign.center : null,
      style: bodyStyle(AppTokens.of(context).muted, small ? 14 : 16));
}
