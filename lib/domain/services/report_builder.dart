import '../entities/measure.dart';
import '../entities/scale.dart';
import '../entities/score.dart';
import '../entities/theme_info.dart';
import 'scoring.dart';

class Report {
  const Report({
    required this.global,
    required this.agree,
    required this.counts,
    required this.skipped,
    required this.byTheme,
  });
  final Score global;
  final Score agree;
  final List<int> counts;
  final int skipped;
  final Map<String, Score> byTheme;
}

Report buildReport({
  required List<ThemeInfo> themes,
  required List<Measure> measures,
  required Iterable<int> ids,
  required Answers answers,
  required Comments comments,
}) {
  final c = counts(ids, answers);
  return Report(
    global: score(ids, answers),
    agree: agreeShare(ids, answers),
    counts: c.counts,
    skipped: c.skipped,
    byTheme: {
      for (final t in themes)
        t.id: score(ids.where((id) => measures[id].theme == t.id), answers),
    },
  );
}

String pctText(int? p) => p == null ? '—' : '$p %';

String reportAsText({
  required String name,
  required bool full,
  required List<ThemeInfo> themes,
  required List<Measure> measures,
  required Iterable<int> ids,
  required Answers answers,
  required Comments comments,
}) {
  final r = buildReport(
      themes: themes, measures: measures, ids: ids, answers: answers, comments: comments);
  String themeName(String id) => themes.firstWhere((t) => t.id == id).name;
  final l = <String>[
    'Boussole des mesures — rapport de ${name.isEmpty ? 'moi' : name} (version ${full ? 'complète' : 'courte'})',
    'Accord global : ${pctText(r.global.pct)} sur ${r.global.n} mesures notées',
    'Mesures approuvées (d’accord ou plutôt d’accord) : ${pctText(r.agree.pct)}',
    '',
    for (final s in scale) '- ${s.label} : ${r.counts[s.value]}',
    '',
    'Par thème :',
    for (final t in themes)
      '- ${t.name} : ${pctText(r.byTheme[t.id]!.pct)} (${r.byTheme[t.id]!.n} notées)',
  ];
  final withC = ids.where((id) => (comments[id] ?? '').isNotEmpty).toList();
  if (withC.isNotEmpty) {
    l..add('')..add('Commentaires :');
    for (final id in withC) {
      final m = measures[id];
      final a = answers[id];
      l.add('- ${themeName(m.theme)} n° ${m.no} : ${m.text} [${a == null ? 'passée' : scale[a].label}] : ${comments[id]}');
    }
  }
  return l.join('\n');
}
