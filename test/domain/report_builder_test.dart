import 'package:boussole/domain/entities/measure.dart';
import 'package:boussole/domain/entities/theme_info.dart';
import 'package:boussole/domain/services/report_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final themes = [const ThemeInfo('eco', 'Économie'), const ThemeInfo('ins', 'Institutions')];
  final measures = [
    for (var i = 0; i < 4; i++)
      Measure(id: i, no: i + 1, theme: i < 2 ? 'eco' : 'ins', text: 'M$i', phare: i == 0, info: ''),
  ];
  const ids = [0, 1, 2, 3];
  final answers = {0: 5, 1: 4, 2: 2, 3: 0};

  test('buildReport computes global, agree and per-theme scores', () {
    final r = buildReport(
        themes: themes, measures: measures, ids: ids, answers: answers, comments: {});
    expect(r.global.pct, 58);
    expect(r.agree.pct, 67);
    expect(r.byTheme['eco']!.pct, 88);
    expect(r.byTheme['ins']!.pct, 0);
    expect(r.skipped, 0);
  });
  test('reportAsText reproduces the legacy text', () {
    final t = reportAsText(
        name: 'Léa', full: false, themes: themes, measures: measures,
        ids: ids, answers: answers, comments: {3: 'non merci'});
    expect(t, contains('rapport de Léa (version courte)'));
    expect(t, contains('Accord global : 58 % sur 3 mesures notées'));
    expect(t, contains('- Économie : 88 % (2 notées)'));
    expect(t, contains('Commentaires :'));
    expect(t, contains('Institutions n° 4 : M3 [Pas d’accord] : non merci'));
  });
  test('reportAsText shows — when nothing is rated', () {
    final t = reportAsText(
        name: '', full: true, themes: themes, measures: measures,
        ids: ids, answers: {}, comments: {});
    expect(t, contains('rapport de moi (version complète)'));
    expect(t, contains('Accord global : — sur 0 mesures notées'));
  });
}
