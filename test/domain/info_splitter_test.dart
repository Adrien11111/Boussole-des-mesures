import 'dart:convert';
import 'dart:io';
import 'package:boussole/domain/services/info_splitter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('splits context, partisans and critiques', () {
    final r = splitInfo(
        'Le parc social compte 5,4 millions de logements. Pour ses partisans, elle répond à une pénurie ; pour ses critiques, le foncier serait un frein.');
    expect(r, isNotNull);
    expect(r!.ctx, 'Le parc social compte 5,4 millions de logements.');
    expect(r.pro, 'Pour ses partisans, elle répond à une pénurie.');
    expect(r.con, 'Pour ses critiques, le foncier serait un frein.');
  });
  test('handles the "Ses partisans ... ses critiques" form', () {
    final r = splitInfo(
        'Contexte. Ses partisans parlent d’un progrès, ses critiques, d’un risque.');
    expect(r, isNotNull);
    expect(r!.ctx, 'Contexte.');
    expect(r.pro, 'Ses partisans parlent d’un progrès.');
    expect(r.con, 'Ses critiques parlent d’un risque.');
  });
  test('returns null without partisans/critiques', () {
    expect(splitInfo('Un simple texte.'), isNull);
  });
  test('parity with legacy on the real catalog: 1022 splittable, 1 without partisans',
      () {
    final json = jsonDecode(File('assets/measures.json').readAsStringSync())
        as Map<String, dynamic>;
    final infos = (json['measures'] as List).map((m) => m['info'] as String);
    final res = infos.map(splitInfo).whereType<SplitInfo>().toList();
    expect(res.length, 1022);
    expect(res.where((r) => r.pro.isEmpty).length, 1);
  });
}
