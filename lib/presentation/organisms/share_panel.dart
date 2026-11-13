import 'package:flutter/material.dart';

import '../atoms/app_button.dart';
import '../atoms/heading.dart';
import '../design_system/tokens.dart';

/// Code de partage, copie du code / du rapport, comparaison, effacement en deux temps.
class SharePanel extends StatefulWidget {
  const SharePanel({
    super.key,
    required this.code,
    required this.reportText,
    required this.onCopy,
    required this.onCompare,
    required this.onReset,
  });
  final String code;
  final String Function() reportText;
  final Future<bool> Function(String) onCopy;
  final VoidCallback onCompare;
  final VoidCallback onReset;

  @override
  State<SharePanel> createState() => _SharePanelState();
}

class _SharePanelState extends State<SharePanel> {
  String _msg = '';
  bool _armed = false;

  Future<void> _copy(String text, String ok) async {
    final done = await widget.onCopy(text);
    if (!mounted) return;
    setState(() => _msg = done
        ? ok
        : 'Copie impossible ici : sélectionne le texte dans la zone et copie-le à la main.');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Heading('Partager et conserver'),
      const SizedBox(height: 14),
      const MutedText('Copie ton code et envoie-le à tes proches : ils le collent dans l’onglet « Comparer ».', small: true),
      const SizedBox(height: 14),
      SelectableText(widget.code, style: TextStyle(fontFamily: 'Menlo', fontFamilyFallback: const ['Consolas', 'monospace'], fontSize: 12.5, color: t.ink)),
      const SizedBox(height: 14),
      Wrap(spacing: 10, runSpacing: 10, children: [
        AppButton(label: 'Copier mon code', onPressed: () => _copy(widget.code, 'Code copié. Envoie-le à tes proches.')),
        AppButton(label: 'Copier le rapport en texte', ghost: true, onPressed: () => _copy(widget.reportText(), 'Rapport copié en texte.')),
        AppButton(label: 'Comparer avec des proches', ghost: true, onPressed: widget.onCompare),
      ]),
      if (_msg.isNotEmpty) ...[
        const SizedBox(height: 14),
        Semantics(liveRegion: true, child: MutedText(_msg, small: true)),
      ],
      const SizedBox(height: 14),
      AppButton(
        label: _armed ? 'Confirmer l’effacement de toutes mes réponses' : 'Effacer mes réponses',
        ghost: true,
        onPressed: () {
          if (_armed) {
            widget.onReset();
          } else {
            setState(() => _armed = true);
          }
        },
      ),
    ]);
  }
}

