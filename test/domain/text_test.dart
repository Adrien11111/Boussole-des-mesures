import 'package:boussole/domain/services/text.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utf16.dart';

void main() {
  test('truncateText never splits a surrogate pair', () {
    final s = 'a${'😀' * 300}';
    final r = truncateText(s, 500);
    expect(r.length, lessThanOrEqualTo(500));
    expect(isWellFormedUtf16(r), isTrue);
  });
  test('truncateText leaves short text untouched and cuts plain text exactly', () {
    expect(truncateText('abc', 500), 'abc');
    expect(truncateText('a' * 600, 500).length, 500);
  });
}
