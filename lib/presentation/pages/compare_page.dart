import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ports/share_codec_port.dart';
import '../../application/state/app_state.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/scale.dart';
import '../../domain/services/comparison.dart';
import '../../domain/services/report_builder.dart' show pctText;
import '../../domain/services/scoring.dart';
import '../../domain/services/similarity.dart';
import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../molecules/bar_row.dart';
import '../organisms/compare_detail.dart';
import '../organisms/compare_intro.dart';
import '../organisms/compare_matrix.dart';
import '../organisms/footer_note.dart';
import '../state/providers.dart';
import '../templates/page_layout.dart';

class ComparePage extends ConsumerWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appControllerProvider);
    final ctrl = ref.read(appControllerProvider.notifier);
    final cat = ref.read(catalogProvider);
    final codec = ref.read(codecProvider);
    final count = cat.measures.length;
    final myName = s.name.isEmpty ? 'Moi' : s.name;

    final others = <Person>[];
    final storedIndex = <int>[]; // position de chaque proche dans s.others
    for (var k = 0; k < s.others.length; k++) {
      try {
        others.add(codec.decode(s.others[k]));
        storedIndex.add(k);
      } on ShareCodeException {
        // code stocké illisible : ignoré
      }
    }
    final me = Person(name: myName, answers: s.answers, comments: s.comments);
    final ppl = [me, ...others];
    final footer = FooterNote(measureCount: count, pharesCount: cat.measures.where((m) => m.phare).length);

    final intro = CompareIntro(
      myCode: codec.encode(myName, s.answers, s.comments),
      relatives: [for (final p in others) RelativeSummary(p.name, p.answers.length)],
      onCopy: ref.read(clipboardProvider).copy,
      onAdd: ctrl.addOther,
      onRemove: (k) => ctrl.removeOther(storedIndex[k]),
    );
    if (others.isEmpty) return PageLayout(view: AppView.compare, children: [intro, footer]);

    final sel = s.cmpWith.clamp(0, others.length - 1);
    final other = others[sel];
    final allIds = List<int>.generate(count, (i) => i);
    final themeIds = {
      for (final th in cat.themes) th.id: [for (final m in cat.measures) if (m.theme == th.id) m.id],
    };

    String where(int id) {
      final m = cat.measures[id];
      return '${cat.themes.firstWhere((x) => x.id == m.theme).name} n° ${m.no}';
    }

    final common = [for (final id in allIds) if (isRated(s.answers[id]) && isRated(other.answers[id])) id];
    ComparedMeasure cm(int id) => ComparedMeasure(
          where: where(id),
          text: cat.measures[id].text,
          mine: s.answers[id],
          theirs: other.answers[id],
          myComment: s.comments[id],
          theirComment: other.comments[id],
        );
    final apart = mostDivergent(common, s.answers, other.answers, limit: 8).map(cm).toList();
    final together = agreedIds(common, s.answers, other.answers, limit: 6).map(cm).toList();

    final names = [for (final p in ppl) p.name];
    return PageLayout(view: AppView.compare, children: [
      intro,
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Proximité d’avis'),
          const SizedBox(height: 14),
          const MutedText(
              '100 % = mêmes réponses partout ; chaque cran d’écart (par exemple « D’accord » contre '
              '« Plutôt d’accord ») retire 25 points sur la mesure.',
              small: true),
          const SizedBox(height: 14),
          for (final p in others) ...[
            () {
              final sim = similarity(s.answers, p.answers, count);
              return BarRow(
                  label: '$myName et ${p.name}',
                  score: sim,
                  countLabel: '(${sim.n} mesures notées par les deux)');
            }(),
            const SizedBox(height: 10),
          ],
        ]),
      ),
      if (ppl.length > 2)
        CompareMatrix(
          names: names,
          cells: [
            for (var i = 0; i < ppl.length; i++)
              [for (var j = 0; j < ppl.length; j++) i == j ? '—' : pctText(similarity(ppl[i].answers, ppl[j].answers, count).pct)],
          ],
        ),
      CompareThemeTable(names: names, rows: [
        ['Accord global', for (final p in ppl) pctText(score(allIds, p.answers).pct)],
        for (final th in cat.themes) [th.name, for (final p in ppl) pctText(score(themeIds[th.id]!, p.answers).pct)],
      ]),
      CompareDetail(
        myName: myName,
        otherNames: [for (final p in others) p.name],
        selected: sel,
        onSelect: ctrl.selectCompare,
        commonCount: common.length,
        apart: apart,
        together: together,
      ),
      footer,
    ]);
  }
}
