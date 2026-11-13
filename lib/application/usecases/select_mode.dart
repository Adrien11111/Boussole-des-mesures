import '../state/app_state.dart';

AppState selectMode(AppState s, QuizMode mode, {bool startQuiz = false}) =>
    s.copyWith(mode: mode, view: startQuiz ? AppView.quiz : s.view);
