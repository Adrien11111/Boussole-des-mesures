import 'package:boussole/domain/entities/score.dart';
import 'package:boussole/presentation/molecules/answer_option.dart';
import 'package:boussole/presentation/molecules/bar_row.dart';
import 'package:boussole/presentation/molecules/info_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'atoms_test.dart' show host;

void main() {
  testWidgets('BarRow shows — when the score is null', (t) async {
    await t.pumpWidget(host(const BarRow(label: 'Éco', score: Score(null, 0))));
    expect(find.text('—'), findsOneWidget);
  });
  testWidgets('BarRow shows the percentage and count', (t) async {
    await t.pumpWidget(host(const BarRow(label: 'Éco', score: Score(58, 3))));
    expect(find.text('58 %'), findsOneWidget);
    expect(find.textContaining('3 notées'), findsOneWidget);
  });
  testWidgets('AnswerOption reports its selected state and taps', (t) async {
    final h = t.ensureSemantics();
    var taps = 0;
    await t.pumpWidget(host(AnswerOption(
        value: 5, label: 'D’accord', keyHint: 'touche 5', selected: true, onTap: () => taps++)));
    expect(t.getSemantics(find.byType(AnswerOption)),
        isSemantics(isSelected: true, isButton: true));
    await t.tap(find.byType(AnswerOption));
    expect(taps, 1);
    h.dispose();
  });
  testWidgets('InfoTable shows both columns when partisans/critiques exist', (t) async {
    t.view.physicalSize = const Size(1000, 1000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(host(const InfoTable(
        'Contexte. Pour ses partisans, c’est utile ; pour ses critiques, c’est cher.')));
    expect(find.text('PARTISANS DE LA MESURE'), findsOneWidget);
    expect(find.text('CRITIQUES DE LA MESURE'), findsOneWidget);
    expect(find.text('Contexte.'), findsOneWidget);
  });
  testWidgets('InfoTable falls back to plain text', (t) async {
    await t.pumpWidget(host(const InfoTable('Un simple texte.')));
    expect(find.text('Un simple texte.'), findsOneWidget);
    expect(find.text('PARTISANS DE LA MESURE'), findsNothing);
  });
}
