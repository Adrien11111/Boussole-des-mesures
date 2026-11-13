import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ports/share_codec_port.dart';
import '../../domain/services/text.dart';
import '../../application/state/app_state.dart';
import '../../application/usecases/add_other.dart';
import '../../application/usecases/answer_measure.dart';
import '../../application/usecases/navigate_quiz.dart';
import '../../application/usecases/remove_other.dart';
import '../../application/usecases/reset_answers.dart';
import '../../application/usecases/select_mode.dart';
import '../../application/usecases/set_comment.dart' as uc;
import 'providers.dart';

final appControllerProvider =
    NotifierProvider<AppController, AppState>(AppController.new);

class AppController extends Notifier<AppState> {
  @override
  AppState build() => ref.read(initialStateProvider);

  void _commit(AppState s) {
    state = s;
    unawaited(ref.read(storageProvider).save(s));
  }

  void answer(int value) => _commit(answerMeasure(state, ref.read(catalogProvider), value));
  void next() => _commit(step(state, ref.read(catalogProvider), 1));
  void prev() => _commit(step(state, ref.read(catalogProvider), -1));
  void setComment(String text) => _commit(uc.setComment(state, ref.read(catalogProvider), text));
  void setName(String name) =>
      _commit(state.copyWith(name: truncateText(name, 40)));
  void cycleTheme() => _commit(state.copyWith(
      theme: ThemePref.values[(state.theme.index + 1) % ThemePref.values.length]));
  void toggleOpenInfo() => _commit(state.copyWith(openInfo: !state.openInfo));
  void start(QuizMode mode) => _commit(selectMode(state, mode, startQuiz: true));
  void switchMode(QuizMode mode) => _commit(selectMode(state, mode));
  void goTo(AppView view) => state = state.copyWith(view: view);
  void selectCompare(int k) => state = state.copyWith(cmpWith: k);
  void removeOther(int k) => _commit(removeOtherAt(state, k));
  void reset() => _commit(resetAnswers(state));

  /// Renvoie le message d'erreur à afficher, ou null si le code est ajouté.
  String? addOther(String rawCode) {
    try {
      _commit(addOtherCode(state, ref.read(codecProvider), rawCode));
      return null;
    } on ShareCodeException catch (e) {
      return e.message;
    }
  }
}
