import '../../domain/entities/measure.dart';
import '../ports/catalog_port.dart';
import '../state/app_state.dart';

/// Identifiants des mesures du mode, triés par thème, puis `no`, puis `id`.
List<int> measureIdsFor(Catalog cat, QuizMode mode) {
  final order = {for (var k = 0; k < cat.themes.length; k++) cat.themes[k].id: k};
  final list = cat.measures.where((m) => mode == QuizMode.full || m.phare).toList()
    ..sort((Measure a, Measure b) {
      final t = order[a.theme]!.compareTo(order[b.theme]!);
      if (t != 0) return t;
      final n = a.no.compareTo(b.no);
      return n != 0 ? n : a.id.compareTo(b.id);
    });
  return [for (final m in list) m.id];
}

/// Mesure courante du quiz (position bornée).
int currentMeasureId(AppState s, Catalog cat) {
  final ids = measureIdsFor(cat, s.mode);
  final p = (s.pos[s.mode] ?? 0).clamp(0, ids.length - 1);
  return ids[p];
}
