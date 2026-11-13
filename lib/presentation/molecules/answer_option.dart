import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Un bouton du rail de réponse. [vertical] = disposition en colonne (écran large).
class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.value,
    required this.label,
    required this.keyHint,
    required this.selected,
    required this.onTap,
    this.vertical = false,
  });
  final int value;
  final String label;
  final String keyHint;
  final bool selected;
  final VoidCallback onTap;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final c = t.answerColor(value);
    final fg = selected ? t.onAnswer(value) : t.ink;
    final hint = selected ? fg.withValues(alpha: value == 1 ? .6 : .8) : t.muted;
    final barColor = selected ? Colors.white.withValues(alpha: .55) : c;
    final text = [
      Text(label, style: bodyStyle(fg, 16)),
      Text(keyHint, style: bodyStyle(hint, 12, weight: 500)),
    ];
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $keyHint',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? c : t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: selected ? c : t.line, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: vertical ? 92 : 56),
            child: vertical
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 7, color: barColor),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: text),
                    ),
                  ])
                : IntrinsicHeight(
                    child: Row(children: [
                      Container(width: 6, color: barColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Row(
                            children: [
                              Expanded(child: text[0]),
                              const SizedBox(width: 8),
                              text[1],
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
          ),
        ),
      ),
    );
  }
}
