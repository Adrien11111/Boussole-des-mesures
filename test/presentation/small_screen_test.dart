import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/pages/compare_page.dart';
import 'package:boussole/presentation/pages/home_page.dart';
import 'package:boussole/presentation/pages/quiz_page.dart';
import 'package:boussole/presentation/pages/report_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  const phone = Size(320, 640);
  final answered = AppState.initial().copyWith(
    name: 'Alexandrine-Charlotte',
    answers: {0: 5, 1: 0, 2: 3},
    comments: {0: 'Un commentaire assez long pour forcer le retour à la ligne sur un petit écran'},
    mode: QuizMode.full,
    others: ['BM1.Bartholomé-Maximilien', 'BM1.Ana'],
    openInfo: true,
  );

  final pages = <String, Widget>{
    'home': const HomePage(),
    'quiz': const QuizPage(),
    'report': const ReportPage(),
    'compare': const ComparePage(),
  };

  for (final e in pages.entries) {
    for (final scale in [1.0, 1.5]) {
      testWidgets('${e.key} has no overflow at 320 px, text x$scale', (t) async {
        await pumpPage(t, e.value, initial: answered, size: phone, textScale: scale);
        expect(t.takeException(), isNull);
      });
    }
  }
}
