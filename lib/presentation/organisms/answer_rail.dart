import 'package:flutter/material.dart';

import '../../domain/entities/scale.dart';
import '../design_system/tokens.dart';
import '../molecules/answer_option.dart';

/// Rail de réponse (5 niveaux) + bouton « Sans avis ».
class AnswerRail extends StatelessWidget {
  const AnswerRail({super.key, required this.selected, required this.onSelect});
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final wide = MediaQuery.sizeOf(context).width >= wideBreakpoint;
    final opts = [
      for (var k = 0; k < rail.length; k++)
        AnswerOption(
          value: rail[k],
          label: scale[rail[k]].label,
          keyHint: 'touche ${k + 1}',
          selected: selected == rail[k],
          vertical: wide,
          onTap: () => onSelect(rail[k]),
        ),
    ];
    final noOpinion = selected == 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (wide)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (var i = 0; i < opts.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: opts[i]),
            ],
          ]),
        )
      else
        Column(children: [
          for (var i = 0; i < opts.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            opts[i],
          ],
        ]),
      const SizedBox(height: 14),
      Semantics(
        button: true,
        selected: noOpinion,
        child: Material(
          color: noOpinion ? t.ink : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: noOpinion ? t.ink : t.muted, width: 1.5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onSelect(2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Sans avis ', style: bodyStyle(noOpinion ? t.surface : t.muted, 16, weight: 600)),
                TextSpan(text: '(touche 0)', style: bodyStyle(noOpinion ? t.surface : t.muted, 14)),
              ])),
            ),
          ),
        ),
      ),
    ]);
  }
}
