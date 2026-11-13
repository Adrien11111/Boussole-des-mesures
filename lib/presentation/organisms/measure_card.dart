import 'package:flutter/material.dart';

import '../atoms/tag.dart';
import '../design_system/tokens.dart';
import 'info_panel.dart';

/// En-tête d'une mesure : étiquettes, énoncé et volet « En savoir plus ».
class MeasureHeader extends StatelessWidget {
  const MeasureHeader({
    super.key,
    required this.themeName,
    required this.no,
    required this.phare,
    required this.text,
    required this.info,
    required this.openInfoByDefault,
  });
  final String themeName;
  final int no;
  final bool phare;
  final String text;
  final String info;
  final bool openInfoByDefault;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final w = MediaQuery.sizeOf(context).width;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
        Tag(themeName),
        Semantics(
          label: 'Numéro de la mesure dans le programme (votons-2027.fr)',
          child: Text('n° $no',
              style: bodyStyle(t.ink, 16, weight: 700)
                  .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
        ),
        if (phare) const Tag('Mesure phare', outlined: true),
      ]),
      const SizedBox(height: 14),
      Semantics(
        identifier: 'measure',
        child: Text(text, style: displayStyle(t.ink, w < 640 ? 22.4 : 30, weight: 600, height: 1.2)),
      ),
      const SizedBox(height: 14),
      InfoPanel(info: info, openByDefault: openInfoByDefault),
    ]);
  }
}
