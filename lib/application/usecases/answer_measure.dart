import '../ports/catalog_port.dart';
import '../state/app_state.dart';
import 'measure_ids_for.dart';

/// Enregistre [value] pour la mesure courante ; la même valeur deux fois l'efface.
AppState answerMeasure(AppState s, Catalog cat, int value) {
  final id = currentMeasureId(s, cat);
  final a = Map<int, int>.of(s.answers);
  if (a[id] == value) {
    a.remove(id);
  } else {
    a[id] = value;
  }
  return s.copyWith(answers: a);
}
