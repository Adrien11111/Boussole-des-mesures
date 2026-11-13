import 'dart:io';
import 'package:boussole/presentation/design_system/tokens.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

const expected = [
  'Noto Sans',
  'Noto Sans Arabic',
  'Noto Sans Hebrew',
  'Noto Sans Devanagari',
  'Noto Emoji',
];

void main() {
  final pubspec = File('pubspec.yaml').readAsStringSync();

  for (final style in {
    'body': bodyStyle(const Color(0xFF000000), 16),
    'display': displayStyle(const Color(0xFF000000), 16),
  }.entries) {
    test('${style.key} style falls back to every bundled Noto family', () {
      expect(style.value.fontFamilyFallback, containsAll(expected));
    });
  }

  for (final family in expected) {
    test('$family is declared in pubspec with an existing file', () {
      expect(pubspec, contains('family: $family'));
      final file = RegExp('family: $family\\s+fonts:\\s+- asset: (\\S+)').firstMatch(pubspec)?.group(1);
      expect(file, isNotNull);
      expect(File(file!).existsSync(), isTrue, reason: file);
    });
  }

  test('licences of the bundled Noto fonts ship with the app', () {
    expect(pubspec, contains('assets/fonts/OFL-Noto.txt'));
  });
}
