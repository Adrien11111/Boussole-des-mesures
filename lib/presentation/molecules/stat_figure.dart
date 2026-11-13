import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Gros chiffre + légende (ex. « 67 % » des mesures approuvées).
class StatFigure extends StatelessWidget {
  const StatFigure({super.key, required this.figure, required this.caption});
  final String figure;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Text(figure,
            style: displayStyle(t.ink, 25.6).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
        Text(caption, style: bodyStyle(t.muted, 16)),
      ],
    );
  }
}
