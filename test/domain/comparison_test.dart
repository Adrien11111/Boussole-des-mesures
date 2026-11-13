import 'package:boussole/domain/services/comparison.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mostDivergent keeps id order among ties (legacy stable sort), beyond 32 items', () {
    final mine = <int, int>{};
    final theirs = <int, int>{};
    for (var id = 0; id < 100; id++) {
      mine[id] = 5;
      theirs[id] = id % 3 == 0 ? 0 : 5; // écart 100 pour les multiples de 3
    }
    final common = List<int>.generate(100, (i) => i);
    expect(mostDivergent(common, mine, theirs, limit: 8), [0, 3, 6, 9, 12, 15, 18, 21]);
  });
  test('mostDivergent ranks larger gaps first', () {
    final r = mostDivergent([0, 1, 2], {0: 5, 1: 5, 2: 5}, {0: 3, 1: 0, 2: 4}, limit: 8);
    expect(r, [1, 0]); // écart 100, puis 50 ; l'écart 25 est exclu
  });
  test('agreedIds keeps identical non-neutral answers, in id order, capped', () {
    final mine = {0: 5, 1: 3, 2: 4, 3: 0};
    final theirs = {0: 5, 1: 3, 2: 5, 3: 0};
    expect(agreedIds([0, 1, 2, 3], mine, theirs, limit: 6), [0, 3]);
    expect(agreedIds([0, 3], mine, theirs, limit: 1), [0]);
  });
}
