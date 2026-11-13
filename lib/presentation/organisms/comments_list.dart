import 'package:flutter/material.dart';

import '../atoms/pill.dart';
import '../design_system/tokens.dart';

class CommentItem {
  const CommentItem({required this.answer, required this.where, required this.text, required this.comment});
  final int? answer;
  final String where;
  final String text;
  final String comment;
}

class Quote extends StatelessWidget {
  const Quote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(border: Border(left: BorderSide(color: t.line, width: 3))),
      child: Text(text, style: bodyStyle(t.muted, 16).copyWith(fontStyle: FontStyle.italic)),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({super.key, required this.items});
  final List<CommentItem> items;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    if (items.isEmpty) return Text('Tu n’as laissé aucun commentaire.', style: bodyStyle(t.muted, 16));
    return Column(children: [
      for (var i = 0; i < items.length; i++)
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
          padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
          decoration: i == 0 ? null : BoxDecoration(border: Border(top: BorderSide(color: t.line))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Pill(items[i].answer),
              const SizedBox(width: 10),
              Flexible(child: Text(items[i].where, style: bodyStyle(t.muted, 14))),
            ]),
            const SizedBox(height: 4),
            Text(items[i].text, style: bodyStyle(t.ink, 16)),
            const SizedBox(height: 4),
            Quote(items[i].comment),
          ]),
        ),
    ]);
  }
}
