import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final html = File('web/index.html').readAsStringSync();
  final manifest = jsonDecode(File('web/manifest.json').readAsStringSync()) as Map<String, dynamic>;

  test('page declares French and a proper title/description', () {
    expect(html, contains('<html lang="fr">'));
    expect(html, contains('<title>Boussole des mesures</title>'));
    expect(html, isNot(contains('A new Flutter project')));
    expect(html, contains('name="apple-mobile-web-app-title" content="Boussole des mesures"'));
  });

  test('web manifest is branded and French', () {
    expect(manifest['name'], 'Boussole des mesures');
    expect(manifest['short_name'], 'Boussole');
    expect(manifest['lang'], 'fr');
    expect(manifest['description'], isNot(contains('A new Flutter project')));
  });
}
