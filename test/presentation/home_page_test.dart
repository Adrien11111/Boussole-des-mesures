import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('announces the number of measures of each version', (t) async {
    await pumpPage(t, const HomePage());
    expect(tester(t, 'count-short'), '2');
    expect(tester(t, 'count-full'), '3');
  });

  testWidgets('starting a version opens the quiz in that mode', (t) async {
    final h = await pumpPage(t, const HomePage());
    await t.tap(find.text('VERSION COMPLÈTE'));
    await t.pump();
    expect(h.state.mode, QuizMode.full);
    expect(h.state.view, AppView.quiz);
  });

  testWidgets('offers to resume once something is rated', (t) async {
    await pumpPage(t, const HomePage(), initial: AppState.initial().copyWith(answers: {0: 5}));
    expect(find.text('Reprendre où tu t’es arrêté'), findsOneWidget);
    expect(find.text('1 mesures déjà notées'), findsOneWidget);
  });

  testWidgets('no resume card on a fresh start', (t) async {
    await pumpPage(t, const HomePage());
    expect(find.text('Reprendre où tu t’es arrêté'), findsNothing);
  });
}

String tester(WidgetTester t, String key) =>
    (t.widget(find.byKey(Key(key))) as Text).data!;
