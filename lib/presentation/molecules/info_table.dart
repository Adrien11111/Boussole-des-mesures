import 'package:flutter/material.dart';

import '../../domain/services/info_splitter.dart';
import '../design_system/tokens.dart';

/// « En savoir plus » : contexte + colonnes partisans / critiques.
class InfoTable extends StatelessWidget {
  const InfoTable(this.info, {super.key});
  final String info;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final p = splitInfo(info);
    if (p == null) return Text(info, style: bodyStyle(t.ink, 16));
    final pro = p.pro.isEmpty ? 'Aucun argument de ce côté n’est résumé ici.' : p.pro;
    Widget cell(String title, String body, Color accent, {required bool first, required bool stacked}) =>
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 10, 12, 10),
          decoration: BoxDecoration(
            color: t.soft,
            border: Border.all(color: t.line),
            borderRadius: stacked
                ? BorderRadius.vertical(
                    top: Radius.circular(first ? 10 : 0), bottom: Radius.circular(first ? 0 : 10))
                : BorderRadius.horizontal(
                    left: Radius.circular(first ? 10 : 0), right: Radius.circular(first ? 0 : 10)),
          ),
          foregroundDecoration: BoxDecoration(
            border: Border(left: BorderSide(color: accent, width: 3)),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title.toUpperCase(), style: bodyStyle(t.muted, 12, weight: 600).copyWith(letterSpacing: .5)),
            const SizedBox(height: 4),
            Text(body, style: bodyStyle(t.ink, 14.7, height: 1.45)),
          ]),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (p.ctx.isNotEmpty) ...[
        Text(p.ctx, style: bodyStyle(t.ink, 16)),
        const SizedBox(height: 10),
      ],
      LayoutBuilder(builder: (context, c) {
        final stacked = c.maxWidth < 560;
        final a = cell('Partisans de la mesure', pro, t.s5, first: true, stacked: stacked);
        final b = cell('Critiques de la mesure', p.con, t.s0, first: false, stacked: stacked);
        return stacked
            ? Column(children: [a, b])
            : IntrinsicHeight(
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(child: a),
                  Expanded(child: b),
                ]));
      }),
    ]);
  }
}
