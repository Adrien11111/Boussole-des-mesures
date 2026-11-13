import 'package:flutter/material.dart';

import '../atoms/app_button.dart';
import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../atoms/text_field_box.dart';
import '../design_system/tokens.dart';

class RelativeSummary {
  const RelativeSummary(this.name, this.rated);
  final String name;
  final int rated;
}

/// Carte « Comparer avec tes proches » : mon code, ajout d'un code, liste des proches.
class CompareIntro extends StatefulWidget {
  const CompareIntro({
    super.key,
    required this.myCode,
    required this.relatives,
    required this.onCopy,
    required this.onAdd,
    required this.onRemove,
  });
  final String myCode;
  final List<RelativeSummary> relatives;
  final Future<bool> Function(String) onCopy;
  /// Renvoie un message d'erreur, ou null si le code a été ajouté.
  final String? Function(String) onAdd;
  final ValueChanged<int> onRemove;

  @override
  State<CompareIntro> createState() => _CompareIntroState();
}

class _CompareIntroState extends State<CompareIntro> {
  final _code = TextEditingController();
  String _error = '';
  String _msg = '';

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return CardSurface(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Heading('Comparer avec tes proches'),
        const SizedBox(height: 14),
        const MutedText(
            'Chacun note de son côté, puis envoie son code (onglet « Mon rapport »). Colle ici les codes '
            'reçus : la comparaison se fait sur les mesures notées par les deux personnes.'),
        const SizedBox(height: 14),
        TextFieldBox(label: 'Ton code', initialValue: widget.myCode, readOnly: true, mono: true, minLines: 3, maxLines: 5),
        const SizedBox(height: 14),
        Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
          AppButton(
            label: 'Copier mon code',
            ghost: true,
            onPressed: () async {
              final ok = await widget.onCopy(widget.myCode);
              if (mounted) setState(() => _msg = ok ? 'Code copié.' : 'Copie impossible ici : sélectionne le texte dans la zone et copie-le à la main.');
            },
          ),
          if (_msg.isNotEmpty) Semantics(liveRegion: true, child: MutedText(_msg, small: true)),
        ]),
        const SizedBox(height: 14),
        TextFieldBox(
          key: const Key('other-code'),
          label: 'Code d’un proche',
          controller: _code,
          hint: 'Colle ici un code qui commence par BM1.',
          mono: true,
          minLines: 3,
          maxLines: 5,
        ),
        const SizedBox(height: 14),
        Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
          AppButton(
            label: 'Ajouter cette personne',
            onPressed: () {
              final err = widget.onAdd(_code.text);
              setState(() => _error = err ?? '');
              if (err == null) _code.clear();
            },
          ),
          if (_error.isNotEmpty)
            Semantics(liveRegion: true, child: Text(_error, style: bodyStyle(t.s0, 14, weight: 600))),
        ]),
        const SizedBox(height: 14),
        if (widget.relatives.isEmpty)
          const MutedText('Personne n’a encore été ajouté.')
        else
          for (var k = 0; k < widget.relatives.length; k++)
            Container(
              margin: EdgeInsets.only(top: k == 0 ? 0 : 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: t.line), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Expanded(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: widget.relatives[k].name, style: bodyStyle(t.ink, 16, weight: 700)),
                    TextSpan(text: '  ${widget.relatives[k].rated} mesures notées', style: bodyStyle(t.muted, 14)),
                  ])),
                ),
                AppButton(label: 'Retirer', ghost: true, onPressed: () => widget.onRemove(k)),
              ]),
            ),
      ]),
    );
  }
}
