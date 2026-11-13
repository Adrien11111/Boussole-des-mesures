import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/app_state.dart';
import '../../application/usecases/measure_ids_for.dart';
import '../../domain/entities/scale.dart';
import '../../domain/services/report_builder.dart';
import '../../domain/services/scoring.dart';
import '../atoms/app_button.dart';
import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../design_system/tokens.dart';
import '../molecules/bar_row.dart';
import '../molecules/stat_figure.dart';
import '../organisms/comments_list.dart';
import '../organisms/footer_note.dart';
import '../organisms/gauge.dart';
import '../organisms/share_panel.dart';
import '../organisms/stacked_distribution.dart';
import '../organisms/top_list.dart';
import '../state/providers.dart';
import '../templates/page_layout.dart';

class ReportPage extends ConsumerWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appControllerProvider);
    final ctrl = ref.read(appControllerProvider.notifier);
    final cat = ref.read(catalogProvider);
    final t = AppTokens.of(context);
    final full = s.mode == QuizMode.full;
    final ids = measureIdsFor(cat, s.mode);
    final footer = FooterNote(
        measureCount: cat.measures.length, pharesCount: measureIdsFor(cat, QuizMode.short).length);
    final r = buildReport(
        themes: cat.themes, measures: cat.measures, ids: ids, answers: s.answers, comments: s.comments);

    if (r.global.n == 0) {
      return PageLayout(view: AppView.report, children: [
        CardSurface(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Heading('Ton rapport apparaîtra ici'),
            const SizedBox(height: 14),
            const MutedText('Note au moins une mesure (autrement que « Sans avis ») pour obtenir ton pourcentage d’accord.'),
            const SizedBox(height: 14),
            AppButton(label: 'Commencer à noter', onPressed: () => ctrl.goTo(AppView.quiz)),
          ]),
        ),
        footer,
      ]);
    }

    String where(int id) {
      final m = cat.measures[id];
      return '${cat.themes.firstWhere((x) => x.id == m.theme).name} n° ${m.no}';
    }

    final rated = ids.where((id) => isRated(s.answers[id])).toList();
    TopListItem item(int id) =>
        TopListItem(answer: s.answers[id], where: where(id), text: cat.measures[id].text);
    final yes = rated.where((id) => s.answers[id] == 5).take(5).map(item).toList();
    final no = rated.reversed.where((id) => s.answers[id] == 0).take(5).map(item).toList();
    final comments = ids
        .where((id) => (s.comments[id] ?? '').isNotEmpty)
        .map((id) => CommentItem(
            answer: s.answers[id], where: where(id), text: cat.measures[id].text, comment: s.comments[id]!))
        .toList();

    final n = r.global.n;
    final plural = n > 1 ? 's' : '';
    final otherMode = full ? QuizMode.short : QuizMode.full;
    final pids = ids.where((id) => cat.measures[id].phare);
    final oids = ids.where((id) => !cat.measures[id].phare);

    return PageLayout(view: AppView.report, children: [
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 10, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Heading('Rapport de ${s.name.isEmpty ? 'ton opinion' : s.name}'),
              MutedText('Version ${full ? 'complète' : 'courte'}', small: true),
            ]),
            AppButton(
                label: 'Passer à la version ${otherMode == QuizMode.full ? 'complète' : 'courte'}',
                ghost: true,
                onPressed: () => ctrl.switchMode(otherMode)),
          ]),
          const SizedBox(height: 14),
          Gauge(pct: r.global.pct!, caption: 'd’accord avec les idées, sur $n mesure$plural notée$plural'),
          const SizedBox(height: 14),
          const MutedText(
              'Calcul : d’accord = 100 %, plutôt d’accord = 75 %, neutre = 50 %, plutôt pas d’accord = 25 %, '
              'pas d’accord = 0 %. « Sans avis » et les mesures passées ne comptent pas.',
              small: true, center: true),
          const SizedBox(height: 14),
          StatFigure(
              figure: pctText(r.agree.pct),
              caption: 'des mesures notées reçoivent un accord (d’accord ou plutôt d’accord)'),
          if (r.skipped > 0) ...[
            const SizedBox(height: 14),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, children: [
              Text(
                  'Il reste ${r.skipped} mesure${r.skipped > 1 ? 's' : ''} non notée${r.skipped > 1 ? 's' : ''} dans cette version.',
                  style: bodyStyle(t.muted, 14)),
              AppButton(label: 'Continuer à noter', ghost: true, onPressed: () => ctrl.goTo(AppView.quiz)),
            ]),
          ],
        ]),
      ),
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Répartition de tes réponses'),
          const SizedBox(height: 14),
          StackedDistribution(counts: r.counts, skipped: r.skipped, total: ids.length),
        ]),
      ),
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Accord par thème'),
          const SizedBox(height: 14),
          for (final th in cat.themes) ...[
            BarRow(label: th.name, score: r.byTheme[th.id]!),
            const SizedBox(height: 10),
          ],
        ]),
      ),
      if (full)
        CardSurface(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Heading('Mesures phares et autres mesures'),
            const SizedBox(height: 14),
            BarRow(label: 'Mesures phares', score: score(pids, s.answers)),
            const SizedBox(height: 10),
            BarRow(label: 'Autres mesures', score: score(oids, s.answers)),
          ]),
        ),
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Tes accords les plus nets'),
          const SizedBox(height: 14),
          TopList(items: yes, emptyMessage: 'Aucune mesure notée « D’accord » pour l’instant.'),
        ]),
      ),
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Tes désaccords les plus nets'),
          const SizedBox(height: 14),
          TopList(items: no, emptyMessage: 'Aucune mesure notée « Pas d’accord » pour l’instant.'),
        ]),
      ),
      CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Tes commentaires'),
          const SizedBox(height: 14),
          CommentsList(items: comments),
        ]),
      ),
      CardSurface(
        child: SharePanel(
          code: ref.read(codecProvider).encode(s.name.isEmpty ? 'Moi' : s.name, s.answers, s.comments),
          reportText: () => reportAsText(
              name: s.name, full: full, themes: cat.themes, measures: cat.measures,
              ids: ids, answers: s.answers, comments: s.comments),
          onCopy: ref.read(clipboardProvider).copy,
          onCompare: () => ctrl.goTo(AppView.compare),
          onReset: ctrl.reset,
        ),
      ),
      footer,
    ]);
  }
}
