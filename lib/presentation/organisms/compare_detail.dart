import 'package:flutter/material.dart';

import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../atoms/pill.dart';
import '../design_system/tokens.dart';
import 'comments_list.dart';

class ComparedMeasure {
  const ComparedMeasure({
    required this.where,
    required this.text,
    required this.mine,
    required this.theirs,
    this.myComment,
    this.theirComment,
  });
  final String where, text;
  final int? mine, theirs;
  final String? myComment, theirComment;
}

class CompareDetail extends StatelessWidget {
  const CompareDetail({
    super.key,
    required this.myName,
    required this.otherNames,
    required this.selected,
    required this.onSelect,
    required this.commonCount,
    required this.apart,
    required this.together,
  });
  final String myName;
  final List<String> otherNames;
  final int selected;
  final ValueChanged<int> onSelect;
  final int commonCount;
  final List<ComparedMeasure> apart, together;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final other = otherNames[selected];
    Widget list(List<ComparedMeasure> items, String empty) {
      if (items.isEmpty) return MutedText(empty);
      return Column(children: [
        for (var i = 0; i < items.length; i++)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
            padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
            decoration: i == 0 ? null : BoxDecoration(border: Border(top: BorderSide(color: t.line))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text.rich(TextSpan(children: [
                TextSpan(text: '${items[i].where} · ', style: bodyStyle(t.muted, 14)),
                TextSpan(text: items[i].text, style: bodyStyle(t.ink, 16)),
              ])),
              const SizedBox(height: 4),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 10, runSpacing: 4, children: [
                Text(myName, style: bodyStyle(t.muted, 14)),
                Pill(items[i].mine),
                Text(other, style: bodyStyle(t.muted, 14)),
                Pill(items[i].theirs),
              ]),
              if (items[i].myComment != null) ...[const SizedBox(height: 4), Quote('$myName : ${items[i].myComment}')],
              if (items[i].theirComment != null) ...[const SizedBox(height: 4), Quote('$other : ${items[i].theirComment}')],
            ]),
          ),
      ]);
    }

    return CardSurface(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Heading('Détail : $myName et $other'),
        const SizedBox(height: 14),
        if (otherNames.length > 1) ...[
          Text('Comparer en détail avec', style: bodyStyle(t.ink, 14.4, weight: 600)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            initialValue: selected,
            items: [for (var k = 0; k < otherNames.length; k++) DropdownMenuItem(value: k, child: Text(otherNames[k]))],
            onChanged: (v) => onSelect(v ?? 0),
            decoration: InputDecoration(
              filled: true,
              fillColor: t.soft,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.line)),
            ),
          ),
          const SizedBox(height: 14),
        ],
        const Heading('Là où vous divergez le plus', level: 3),
        const SizedBox(height: 10),
        list(apart, 'Aucun écart important sur les $commonCount mesures notées par vous deux.'),
        const SizedBox(height: 14),
        const Heading('Là où vous êtes d’accord', level: 3),
        const SizedBox(height: 10),
        list(together, 'Pas encore de réponse identique et tranchée.'),
      ]),
    );
  }
}
