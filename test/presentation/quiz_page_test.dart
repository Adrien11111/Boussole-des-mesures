import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

AppState quizState({int pos = 0}) => AppState.initial()
    .copyWith(view: AppView.quiz, pos: {QuizMode.short: pos, QuizMode.full: 0});

void main() {
  testWidgets('keyboard 3 selects Neutre for the current measure', (t) async {
    final h = await pumpPage(t, const QuizPage(), initial: quizState());
    await t.sendKeyEvent(LogicalKeyboardKey.digit3);
    await t.pump();
    expect(h.state.answers, {0: 3});
  });

  testWidgets('keyboard 0 selects Sans avis; arrows navigate', (t) async {
    final h = await pumpPage(t, const QuizPage(), initial: quizState());
    await t.sendKeyEvent(LogicalKeyboardKey.digit0);
    expect(h.state.answers, {0: 2});
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(h.state.pos[QuizMode.short], 1);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(h.state.pos[QuizMode.short], 0);
  });

  testWidgets('shortcuts are ignored while typing in the comment field', (t) async {
    final h = await pumpPage(t, const QuizPage(), initial: quizState());
    await t.tap(find.byType(TextFormField));
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.digit1);
    await t.pump();
    expect(h.state.answers, isEmpty);
  });

  testWidgets('tapping an option records the answer', (t) async {
    final h = await pumpPage(t, const QuizPage(), initial: quizState());
    await t.tap(find.text('D’accord'));
    await t.pump();
    expect(h.state.answers, {0: 5});
  });

  testWidgets('last measure offers Voir mon rapport', (t) async {
    await pumpPage(t, const QuizPage(), initial: quizState(pos: 1));
    expect(find.text('Voir mon rapport'), findsOneWidget);
  });

  testWidgets('shows position and theme of the measure', (t) async {
    await pumpPage(t, const QuizPage(), initial: quizState());
    expect(find.textContaining('Mesure 1 sur 2'), findsOneWidget);
    expect(find.text('ÉCONOMIE'), findsOneWidget);
    expect(find.text('Passer →'), findsOneWidget);
  });
}
