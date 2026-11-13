import '../../domain/entities/scale.dart';

enum QuizMode { short, full }

enum ThemePref { auto, light, dark }

enum AppView { home, quiz, report, compare }

class AppState {
  const AppState({
    required this.theme,
    required this.openInfo,
    required this.name,
    required this.mode,
    required this.view,
    required this.answers,
    required this.comments,
    required this.pos,
    required this.others,
    required this.cmpWith,
  });

  factory AppState.initial() => const AppState(
        theme: ThemePref.auto,
        openInfo: false,
        name: '',
        mode: QuizMode.short,
        view: AppView.home,
        answers: {},
        comments: {},
        pos: {QuizMode.short: 0, QuizMode.full: 0},
        others: [],
        cmpWith: 0,
      );

  final ThemePref theme;
  final bool openInfo;
  final String name;
  final QuizMode mode;
  final AppView view;
  final Answers answers;
  final Comments comments;
  final Map<QuizMode, int> pos;
  /// Codes de partage `BM1.` des proches.
  final List<String> others;
  final int cmpWith;

  AppState copyWith({
    ThemePref? theme,
    bool? openInfo,
    String? name,
    QuizMode? mode,
    AppView? view,
    Answers? answers,
    Comments? comments,
    Map<QuizMode, int>? pos,
    List<String>? others,
    int? cmpWith,
  }) =>
      AppState(
        theme: theme ?? this.theme,
        openInfo: openInfo ?? this.openInfo,
        name: name ?? this.name,
        mode: mode ?? this.mode,
        view: view ?? this.view,
        answers: answers ?? this.answers,
        comments: comments ?? this.comments,
        pos: pos ?? this.pos,
        others: others ?? this.others,
        cmpWith: cmpWith ?? this.cmpWith,
      );
}
