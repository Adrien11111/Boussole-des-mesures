import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/app_state.dart';
import '../../application/usecases/measure_ids_for.dart';
import '../atoms/app_button.dart';
import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../atoms/text_field_box.dart';
import '../design_system/tokens.dart';
import '../molecules/mode_card.dart';
import '../organisms/footer_note.dart';
import '../state/providers.dart';
import '../templates/page_layout.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appControllerProvider);
    final ctrl = ref.read(appControllerProvider.notifier);
    final cat = ref.read(catalogProvider);
    final t = AppTokens.of(context);
    final nShort = measureIdsFor(cat, QuizMode.short).length;
    final nFull = measureIdsFor(cat, QuizMode.full).length;
    final answered = s.answers.length;
    final wide = MediaQuery.sizeOf(context).width >= wideBreakpoint;

    final shortCard = ModeCard(
      title: 'Version courte', count: nShort, countKey: const Key('count-short'),
      description: 'mesures phares, 6 par thème', duration: 'Environ 10 minutes',
      onTap: () => ctrl.start(QuizMode.short),
    );
    final fullCard = ModeCard(
      title: 'Version complète', count: nFull, countKey: const Key('count-full'),
      description: 'mesures sur 8 thèmes', duration: 'Environ 45 minutes, tu peux t’arrêter et reprendre',
      onTap: () => ctrl.start(QuizMode.full),
    );

    return PageLayout(view: AppView.home, children: [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Que penses-tu des mesures ?', level: 1),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
                'Note chaque mesure du programme « L’Avenir en commun » selon ton propre avis. À la fin, '
                'tu obtiens ton pourcentage d’accord, un rapport détaillé, et tu peux comparer avec tes proches.',
                style: bodyStyle(t.muted, 17.6)),
          ),
        ]),
      ),
      if (answered > 0)
        CardSurface(
          child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 10, spacing: 10, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Heading('Reprendre où tu t’es arrêté', level: 3),
              MutedText('$answered mesures déjà notées', small: true),
            ]),
            Wrap(spacing: 10, runSpacing: 10, children: [
              AppButton(label: 'Continuer', onPressed: () => ctrl.goTo(AppView.quiz)),
              AppButton(label: 'Voir mon rapport', ghost: true, onPressed: () => ctrl.goTo(AppView.report)),
            ]),
          ]),
        ),
      CardSurface(
        child: TextFieldBox(
          label: 'Ton prénom (il apparaîtra dans ton code de partage)',
          initialValue: s.name,
          hint: 'Par exemple : Adrien',
          maxLength: 40,
          onChanged: ctrl.setName,
        ),
      ),
      if (wide)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: shortCard),
            const SizedBox(width: 12),
            Expanded(child: fullCard),
          ]),
        )
      else
        Column(children: [shortCard, const SizedBox(height: 12), fullCard]),
      FooterNote(measureCount: cat.measures.length, pharesCount: nShort),
    ]);
  }
}
