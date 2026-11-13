import 'package:flutter/material.dart';

import '../design_system/tokens.dart';
import '../molecules/info_table.dart';

/// « En savoir plus » : volet repliable. Rouvert/fermé selon [openByDefault] à chaque nouvelle mesure.
class InfoPanel extends StatefulWidget {
  const InfoPanel({super.key, required this.info, required this.openByDefault});
  final String info;
  final bool openByDefault;

  @override
  State<InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {
  late bool _open = widget.openByDefault;

  @override
  void didUpdateWidget(InfoPanel old) {
    super.didUpdateWidget(old);
    if (old.openByDefault != widget.openByDefault) _open = widget.openByDefault;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          button: true,
          expanded: _open,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: t.ink, width: 1.5)),
                  child: Icon(_open ? Icons.remove : Icons.add, size: 14, color: t.ink),
                ),
                const SizedBox(width: 8),
                Text('En savoir plus', style: bodyStyle(t.ink, 15.2, weight: 600)),
              ]),
            ),
          ),
        ),
        if (_open) ...[
          InfoTable(widget.info),
          const SizedBox(height: 10),
          Text(
              'Contexte rédigé par Claude à partir de sources publiques, de façon volontairement neutre : '
              'à vérifier avant de s’en servir comme référence.',
              style: bodyStyle(t.muted, 14)),
          const SizedBox(height: 10),
        ],
      ]),
    );
  }
}
