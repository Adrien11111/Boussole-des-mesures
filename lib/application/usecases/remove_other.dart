import '../state/app_state.dart';

AppState removeOtherAt(AppState s, int k) =>
    s.copyWith(others: List<String>.of(s.others)..removeAt(k), cmpWith: 0);
