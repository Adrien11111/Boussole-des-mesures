import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/app_state.dart';
import '../../application/usecases/measure_ids_for.dart';
import '../atoms/app_button.dart';
import '../atoms/card_surface.dart';
import '../atoms/progress_bar.dart';
import '../atoms/text_field_box.dart';
import '../design_system/tokens.dart';
import '../keyboard_shortcuts.dart';
import '../organisms/answer_rail.dart';
import '../organisms/measure_card.dart';
import '../state/providers.dart';
import '../templates/page_layout.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appControllerProvider);
    final ctrl = ref.read(appControllerProvider.notifier);
    final cat = ref.read(catalogProvider);
    final t = AppTokens.of(context);

    final ids = measureIdsFor(cat, s.mode);
    final i = (s.pos[s.mode] ?? 0).clamp(0, ids.length - 1);
    final m = cat.measures[ids[i]];
    final cur = s.answers[m.id];
    final done = ids.where(s.answers.containsKey).length;
    final last = i == ids.length - 1;
    final themeName = cat.themes.firstWhere((x) => x.id == m.theme).name;

    return QuizShortcuts(
      onAnswer: ctrl.answer,
      onStep: (d) => d > 0 ? ctrl.next() : ctrl.prev(),
      child: PageLayout(view: AppView.quiz, scrollResetKey: '${s.mode}-$i', children: [
        CardSurface(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 8, children: [
              Text(
                  'Mesure ${i + 1} sur ${ids.length} · $done notées · version ${s.mode == QuizMode.full ? 'complète' : 'courte'}',
                  style: bodyStyle(t.muted, 14).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              AppButton(label: 'Voir le rapport', ghost: true, onPressed: () => ctrl.goTo(AppView.report)),
            ]),
            const SizedBox(height: 14),
            ProgressBar(value: i + 1, max: ids.length),
            const SizedBox(height: 14),
            MeasureHeader(
              key: ValueKey(m.id),
              themeName: themeName,
              no: m.no,
              phare: m.phare,
              text: m.text,
              info: m.info,
              openInfoByDefault: s.openInfo,
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Semantics(
                button: true,
                toggled: s.openInfo,
                child: Material(
                  color: t.surface,
                  shape: StadiumBorder(side: BorderSide(color: s.openInfo ? t.ink : t.line)),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: ctrl.toggleOpenInfo,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (s.openInfo) ...[
                          Icon(Icons.check, size: 14, color: t.ink),
                          const SizedBox(width: 4),
                        ],
                        Text('« En savoir plus » ouvert par défaut',
                            style: bodyStyle(s.openInfo ? t.ink : t.muted, 13.1)),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            AnswerRail(selected: cur, onSelect: ctrl.answer),
            const SizedBox(height: 14),
            TextFieldBox(
              key: ValueKey('comment-${m.id}'),
              label: 'Commentaire (facultatif)',
              initialValue: s.comments[m.id],
              hint: 'Pourquoi cet avis ? Une nuance, une condition, une question…',
              maxLength: 500,
              minLines: 3,
              maxLines: 6,
              onChanged: ctrl.setComment,
            ),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              AppButton(label: '← Précédente', ghost: true, onPressed: i == 0 ? null : ctrl.prev),
              AppButton(label: last ? 'Voir mon rapport' : (cur == null ? 'Passer →' : 'Suivante →'), onPressed: ctrl.next),
            ]),
          ]),
        ),
      ]),
    );
  }
}
