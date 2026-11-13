import '../ports/catalog_port.dart';
import '../state/app_state.dart';
import 'measure_ids_for.dart';

/// Avance (+1) ou recule (-1) ; au-delà de la dernière mesure, ouvre le rapport.
AppState step(AppState s, Catalog cat, int delta) {
  final len = measureIdsFor(cat, s.mode).length;
  final p = (s.pos[s.mode] ?? 0) + delta;
  if (p >= len) return s.copyWith(view: AppView.report);
  return s.copyWith(pos: {...s.pos, s.mode: p < 0 ? 0 : p});
}
