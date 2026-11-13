import 'package:flutter/material.dart';

import '../../domain/entities/score.dart';
import '../design_system/tokens.dart';

class BarRow extends StatelessWidget {
  const BarRow({super.key, required this.label, required this.score, this.countLabel});
  final String label;
  final Score score;
  /// Remplace le « (n notées) » par défaut (ex. « mesures notées par les deux »).
  final String? countLabel;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final n = score.n;
    final count = countLabel ?? '($n notée${n > 1 ? 's' : ''})';
    final pct = score.pct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: '$label ', style: bodyStyle(t.ink, 15.2)),
          TextSpan(text: count, style: bodyStyle(t.muted, 14)),
        ])),
        const SizedBox(height: 4),
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: (pct ?? 0) / 100,
                minHeight: 10,
                backgroundColor: t.line,
                color: t.s5,
              ),
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(pct == null ? '—' : '$pct %',
                textAlign: TextAlign.right,
                style: bodyStyle(t.ink, 16, weight: 700).copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()])),
          ),
        ]),
      ],
    );
  }
}
