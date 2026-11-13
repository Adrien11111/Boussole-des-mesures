import '../state/app_state.dart';

AppState removeOther(AppState s, int k) =>
    s.copyWith(others: List<String>.of(s.others)..removeAt(k), cmpWith: 0);
