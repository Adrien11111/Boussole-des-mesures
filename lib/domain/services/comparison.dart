import '../entities/scale.dart';

int _gap(int id, Answers a, Answers b) => (scale[a[id]!].weight! - scale[b[id]!].weight!).abs();

/// Mesures où l'écart est ≥ 50, les plus grands écarts d'abord, à égalité par id croissant
/// (tri stable, comme l'ancienne app).
List<int> mostDivergent(Iterable<int> common, Answers a, Answers b, {required int limit}) {
  final l = common.where((id) => _gap(id, a, b) >= 50).toList()
    ..sort((x, y) {
      final d = _gap(y, a, b).compareTo(_gap(x, a, b));
      return d != 0 ? d : x.compareTo(y);
    });
  return l.take(limit).toList();
}

/// Mêmes réponses tranchées (hors « Neutre »), dans l'ordre des ids.
List<int> agreedIds(Iterable<int> common, Answers a, Answers b, {required int limit}) =>
    common.where((id) => _gap(id, a, b) == 0 && a[id] != 3).take(limit).toList();
