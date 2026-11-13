import '../state/app_state.dart';

AppState resetAnswers(AppState s) => s.copyWith(
      answers: const {},
      comments: const {},
      pos: const {QuizMode.short: 0, QuizMode.full: 0},
      view: AppView.home,
    );
