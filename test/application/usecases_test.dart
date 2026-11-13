import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/application/ports/share_codec_port.dart';
import 'package:boussole/application/usecases/add_other.dart';
import 'package:boussole/application/usecases/answer_measure.dart';
import 'package:boussole/application/usecases/measure_ids_for.dart';
import 'package:boussole/application/usecases/navigate_quiz.dart';
import 'package:boussole/application/usecases/remove_other.dart';
import 'package:boussole/application/usecases/reset_answers.dart';
import 'package:boussole/application/usecases/set_comment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fakes.dart';

void main() {
  final cat = testCatalog;
  final s0 = AppState.initial();

  test('measureIdsFor(short) keeps only phares, full keeps all', () {
    expect(measureIdsFor(cat, QuizMode.short), [0, 2]);
    expect(measureIdsFor(cat, QuizMode.full), [0, 1, 2]);
  });

  test('answerMeasure stores the value for the current measure', () {
    expect(answerMeasure(s0, cat, 5).answers, {0: 5});
  });

  test('answering the same value twice clears it', () {
    final s = answerMeasure(answerMeasure(s0, cat, 5), cat, 5);
    expect(s.answers.containsKey(0), isFalse);
  });

  test('step(+1) on the last measure goes to the report', () {
    var s = s0.copyWith(pos: {QuizMode.short: 1, QuizMode.full: 0});
    s = step(s, cat, 1);
    expect(s.view, AppView.report);
  });

  test('step moves within bounds and never below 0', () {
    expect(step(s0, cat, 1).pos[QuizMode.short], 1);
    expect(step(s0, cat, -1).pos[QuizMode.short], 0);
  });

  test('setComment truncates to 500 and removes blank comments', () {
    expect(setComment(s0, cat, 'x' * 600).comments[0]!.length, 500);
    final withC = setComment(s0, cat, 'ok');
    expect(setComment(withC, cat, '  ').comments.containsKey(0), isFalse);
  });

  test('addOther replaces a code with the same first name', () {
    var s = addOther(s0, FakeCodec(), 'BM1.Léa');
    s = addOther(s, FakeCodec(), ' BM1.\nLéa ');
    s = addOther(s, FakeCodec(), 'BM1.Tom');
    expect(s.others, ['BM1.Léa', 'BM1.Tom']);
  });

  test('addOther with an invalid code throws and leaves state untouched', () {
    expect(() => addOther(s0, FakeCodec(), 'zzz'), throwsA(isA<ShareCodeException>()));
    expect(s0.others, isEmpty);
  });

  test('removeOther drops the code and resets cmpWith', () {
    final s = addOther(addOther(s0, FakeCodec(), 'BM1.A'), FakeCodec(), 'BM1.B')
        .copyWith(cmpWith: 1);
    final r = removeOther(s, 0);
    expect(r.others, ['BM1.B']);
    expect(r.cmpWith, 0);
  });

  test('resetAnswers clears answers/comments, resets pos and goes home', () {
    var s = answerMeasure(s0, cat, 5);
    s = setComment(s, cat, 'x').copyWith(view: AppView.report, pos: {QuizMode.short: 1, QuizMode.full: 1});
    final r = resetAnswers(s);
    expect(r.answers, isEmpty);
    expect(r.comments, isEmpty);
    expect(r.pos, {QuizMode.short: 0, QuizMode.full: 0});
    expect(r.view, AppView.home);
  });
}
