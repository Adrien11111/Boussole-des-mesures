import 'package:boussole/domain/services/similarity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('identical answers give 100', () {
    expect(similarity({0: 5, 1: 0}, {0: 5, 1: 0}, 10).pct, 100);
  });
  test('one notch apart removes 25 points', () {
    expect(similarity({0: 5}, {0: 4}, 10).pct, 75);
  });
  test('no common rated measure gives null, not a crash', () {
    final s = similarity({0: 5}, {1: 5}, 10);
    expect(s.pct, isNull);
    expect(s.n, 0);
  });
  test('Sans avis is excluded', () {
    expect(similarity({0: 2}, {0: 5}, 10).pct, isNull);
  });
}
