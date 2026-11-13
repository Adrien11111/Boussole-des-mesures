import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/pages/report_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

AppState reportState(Map<int, int> answers) =>
    AppState.initial().copyWith(view: AppView.report, answers: answers);

void main() {
  testWidgets('empty report invites to start rating', (t) async {
    await pumpPage(t, const ReportPage(), initial: reportState({}));
    expect(find.text('Ton rapport apparaîtra ici'), findsOneWidget);
  });

  testWidgets('only Sans avis still counts as empty', (t) async {
    await pumpPage(t, const ReportPage(), initial: reportState({0: 2}));
    expect(find.text('Ton rapport apparaîtra ici'), findsOneWidget);
  });

  testWidgets('a single D’accord gives 100 %', (t) async {
    await pumpPage(t, const ReportPage(), initial: reportState({0: 5}));
    expect(find.text('100 %'), findsWidgets);
    expect(find.textContaining('sur 1 mesure notée'), findsOneWidget);
  });

  testWidgets('reset needs a confirmation tap', (t) async {
    final h = await pumpPage(t, const ReportPage(), initial: reportState({0: 5}));
    await t.ensureVisible(find.text('Effacer mes réponses'));
    await t.tap(find.text('Effacer mes réponses'));
    await t.pump();
    expect(h.state.answers, {0: 5});
    expect(find.text('Confirmer l’effacement de toutes mes réponses'), findsOneWidget);
    await t.tap(find.text('Confirmer l’effacement de toutes mes réponses'));
    await t.pump();
    expect(h.state.answers, isEmpty);
    expect(h.state.view, AppView.home);
  });

  testWidgets('shows the share code of the user', (t) async {
    await pumpPage(t, const ReportPage(), initial: reportState({0: 5}).copyWith(name: 'Léa'));
    expect(find.text('BM1.Léa'), findsOneWidget);
  });
}
