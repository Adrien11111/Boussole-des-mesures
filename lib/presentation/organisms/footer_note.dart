import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design_system/tokens.dart';

class FooterNote extends StatelessWidget {
  const FooterNote({super.key, required this.measureCount, required this.pharesCount});
  final int measureCount;
  final int pharesCount;

  static final _url = Uri.parse('https://melenchon2027.fr/programme/livre');

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final style = bodyStyle(t.muted, 13.6);
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: t.line))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(TextSpan(style: style, children: [
          TextSpan(
              text: 'Cet outil contient les $measureCount mesures listées par votons-2027.fr '
                  '(dont $pharesCount « phares »), reformulées en une phrase. Le site officiel annonce '
                  '1 069 mesures : il compte à part les « mesures clés » placées en tête de chaque section '
                  'du livre, dont la plupart reprennent une puce déjà présente ici, et son décompte puce '
                  'par puce n’est pas publié ; l’écart de 35 n’a donc pas pu être rattaché à des mesures '
                  'précises. Les textes officiels font foi : '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Semantics(
              link: true,
              child: InkWell(
                onTap: () => launchUrl(_url, mode: LaunchMode.externalApplication),
                child: Text('programme « L’Avenir en commun », édition 2027',
                    style: style.copyWith(decoration: TextDecoration.underline, color: t.ink)),
              ),
            ),
          ),
          const TextSpan(text: '.'),
        ])),
        const SizedBox(height: 6),
        Text(
            'Outil personnel pour comparer des opinions entre proches : ce n’est ni un sondage ni une '
            'consigne de vote. Tes réponses restent dans ton navigateur ; elles ne sont partagées que si '
            'tu envoies ton code.',
            style: style),
      ]),
    );
  }
}
