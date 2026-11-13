import '../entities/scale.dart';
import '../entities/score.dart';

Score score(Iterable<int> ids, Answers a) {
  var s = 0, n = 0;
  for (final id in ids) {
    final v = a[id];
    if (isRated(v)) {
      s += scale[v!].weight!;
      n++;
    }
  }
  return n == 0 ? Score.empty : Score((s / n).round(), n);
}

Score agreeShare(Iterable<int> ids, Answers a) {
  var agree = 0, n = 0;
  for (final id in ids) {
    final v = a[id];
    if (isRated(v)) {
      n++;
      if (v! >= 4) agree++;
    }
  }
  return n == 0 ? Score.empty : Score((100 * agree / n).round(), n);
}

({List<int> counts, int skipped}) counts(Iterable<int> ids, Answers a) {
  final c = List<int>.filled(6, 0);
  var skipped = 0;
  for (final id in ids) {
    final v = a[id];
    if (v == null) {
      skipped++;
    } else {
      c[v]++;
    }
  }
  return (counts: c, skipped: skipped);
}
