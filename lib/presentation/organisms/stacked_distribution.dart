import 'package:flutter/material.dart';

import '../../domain/entities/scale.dart';
import '../design_system/tokens.dart';

/// Répartition des réponses : barre empilée + légende.
class StackedDistribution extends StatelessWidget {
  const StackedDistribution({super.key, required this.counts, required this.skipped, required this.total});
  final List<int> counts;
  final int skipped;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    Widget dot(Color c) => Container(
        width: 10, height: 10, margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)));
    Widget item(Color c, String label, int n) => Row(mainAxisSize: MainAxisSize.min, children: [
          dot(c),
          Flexible(
            child: Text('$label · $n',
                style: bodyStyle(t.ink, 14).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
          ),
        ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Semantics(
        label: 'Répartition des réponses',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 18,
            color: t.line,
            child: Row(children: [
              for (final s in scale)
                if (total > 0 && counts[s.value] > 0)
                  Expanded(flex: counts[s.value], child: Tooltip(
                      message: '${s.label} : ${counts[s.value]}',
                      child: Container(color: t.answerColor(s.value)))),
              if (total > 0 && total - counts.fold<int>(0, (a, b) => a + b) > 0)
                Spacer(flex: total - counts.fold<int>(0, (a, b) => a + b)),
            ]),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Wrap(spacing: 16, runSpacing: 6, children: [
        for (final s in scale) item(t.answerColor(s.value), s.label, counts[s.value]),
        item(t.line, 'Passées', skipped),
      ]),
    ]);
  }
}
