import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Tableau à colonnes numériques alignées à droite ; défile à l'horizontale si besoin.
class SimpleTable extends StatelessWidget {
  const SimpleTable({super.key, required this.headers, required this.rows, this.boldRows = const {}});
  final List<String> headers;
  final List<List<String>> rows;
  final Set<int> boldRows;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    Widget cell(String s, {required bool head, required bool first, bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(s,
              textAlign: first ? TextAlign.left : TextAlign.right,
              style: bodyStyle(t.ink, 14.4, weight: head || first || bold ? 650 : 400)
                  .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
        );
    final border = BoxDecoration(border: Border(bottom: BorderSide(color: t.line)));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(decoration: border, children: [
            for (var c = 0; c < headers.length; c++) cell(headers[c], head: true, first: c == 0),
          ]),
          for (var r = 0; r < rows.length; r++)
            TableRow(decoration: border, children: [
              for (var c = 0; c < rows[r].length; c++)
                cell(rows[r][c], head: false, first: c == 0, bold: boldRows.contains(r)),
            ]),
        ],
      ),
    );
  }
}
