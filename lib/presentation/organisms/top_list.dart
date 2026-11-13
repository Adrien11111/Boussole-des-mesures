import 'package:flutter/material.dart';

import '../atoms/pill.dart';
import '../design_system/tokens.dart';

class TopListItem {
  const TopListItem({required this.answer, required this.where, required this.text});
  final int? answer;
  final String where; // « Économie n° 12 »
  final String text;
}

class TopList extends StatelessWidget {
  const TopList({super.key, required this.items, required this.emptyMessage});
  final List<TopListItem> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    if (items.isEmpty) return Text(emptyMessage, style: bodyStyle(t.muted, 16));
    return Column(children: [
      for (var i = 0; i < items.length; i++)
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
          padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
          decoration: i == 0 ? null : BoxDecoration(border: Border(top: BorderSide(color: t.line))),
          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
            Pill(items[i].answer),
            Text.rich(TextSpan(children: [
              TextSpan(text: '${items[i].where} · ', style: bodyStyle(t.muted, 14)),
              TextSpan(text: items[i].text, style: bodyStyle(t.ink, 16)),
            ])),
          ]),
        ),
    ]);
  }
}
