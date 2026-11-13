import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = jsonDecode(File('assets/measures.json').readAsStringSync())
      as Map<String, dynamic>;
  final measures = (json['measures'] as List).cast<Map<String, dynamic>>();
  final themes = (json['themes'] as List).cast<Map<String, dynamic>>();

  test('contains 1034 measures of which 48 are phares', () {
    expect(measures.length, 1034);
    expect(measures.where((m) => m['phare'] == true).length, 48);
  });
  test('themes are in the legacy order', () {
    expect(themes.map((t) => t['id']).toList(),
        ['eco', 'ins', 'clim', 'eur', 'san', 'edu', 'sec', 'imm']);
  });
  test('ids are contiguous from 0', () {
    expect(measures.map((m) => m['id']).toList(),
        List.generate(1034, (i) => i));
  });
  test('first measure matches legacy', () {
    expect(measures[0]['no'], 1);
    expect(measures[0]['text'],
        startsWith('Construire 200 000 logements publics'));
  });
}
