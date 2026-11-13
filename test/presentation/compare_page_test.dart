import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/pages/compare_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

AppState cmp({List<String> others = const []}) =>
    AppState.initial().copyWith(view: AppView.compare, others: others);

void main() {
  testWidgets('no relative yet', (t) async {
    await pumpPage(t, const ComparePage(), initial: cmp());
    expect(find.text('Personne n’a encore été ajouté.'), findsOneWidget);
  });

  testWidgets('invalid code shows the French error under the field', (t) async {
    await pumpPage(t, const ComparePage(), initial: cmp());
    await t.enterText(find.byKey(const Key('other-code')), 'zzz');
    await t.ensureVisible(find.text('Ajouter cette personne'));
    await t.tap(find.text('Ajouter cette personne'));
    await t.pump();
    expect(find.text('Ce code n’est pas reconnu. Il doit commencer par BM1.'), findsOneWidget);
  });

  testWidgets('valid code adds the relative', (t) async {
    final h = await pumpPage(t, const ComparePage(), initial: cmp());
    await t.enterText(find.byKey(const Key('other-code')), 'BM1.Tom');
    await t.ensureVisible(find.text('Ajouter cette personne'));
    await t.tap(find.text('Ajouter cette personne'));
    await t.pump();
    expect(h.state.others, ['BM1.Tom']);
  });

  testWidgets('duo matrix only appears from two relatives', (t) async {
    await pumpPage(t, const ComparePage(), initial: cmp(others: ['BM1.A']));
    expect(find.text('Tous les duos'), findsNothing);
    await pumpPage(t, const ComparePage(), initial: cmp(others: ['BM1.A', 'BM1.B']));
    expect(find.text('Tous les duos'), findsOneWidget);
  });

  testWidgets('no common rated measure shows — instead of crashing', (t) async {
    await pumpPage(t, const ComparePage(), initial: cmp(others: ['BM1.A']));
    expect(find.text('—'), findsWidgets);
  });

  testWidgets('Retirer removes the right person even if a stored code is undecodable', (t) async {
    final h = await pumpPage(t, const ComparePage(), initial: cmp(others: ['garbage', 'BM1.Ana', 'BM1.Bob']));
    await t.ensureVisible(find.text('Retirer').last);
    await t.tap(find.text('Retirer').last); // Bob
    await t.pump();
    expect(h.state.others, ['garbage', 'BM1.Ana']);
  });
}
