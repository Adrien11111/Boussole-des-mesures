import 'package:boussole/domain/services/scoring.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ids = [0, 1, 2, 3];
  test('score averages weights of rated answers, ignoring Sans avis', () {
    final s = score(ids, {0: 5, 1: 4, 2: 2, 3: 0});
    expect(s.pct, 58);
    expect(s.n, 3);
  });
  test('score is null when nothing is answered', () {
    final s = score(ids, {});
    expect(s.pct, isNull);
    expect(s.n, 0);
  });
  test('score is null when only Sans avis is answered', () {
    expect(score(ids, {0: 2, 1: 2}).pct, isNull);
  });
  test('agreeShare counts answers >= 4 among rated', () {
    expect(agreeShare([0, 1, 2], {0: 5, 1: 4, 2: 3}).pct, 67);
  });
  test('counts separates skipped from answered, keeps Sans avis', () {
    final c = counts(ids, {0: 5, 1: 2});
    expect(c.counts, [0, 0, 1, 0, 0, 1]);
    expect(c.skipped, 2);
  });
}
