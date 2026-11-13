import 'package:flutter/material.dart';

import '../../domain/entities/scale.dart';
import '../design_system/tokens.dart';

/// Pastille de réponse ; `null` = mesure passée.
class Pill extends StatelessWidget {
  const Pill(this.value, {super.key});
  final int? value;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final v = value;
    final dashed = v == null || v == 2;
    final bg = dashed ? Colors.transparent : t.answerColor(v);
    final fg = dashed ? t.muted : t.onAnswer(v);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
        border: dashed ? Border.all(color: v == null ? t.line : t.muted) : null,
      ),
      child: Text(v == null ? 'Passée' : scale[v].label,
          style: bodyStyle(fg, 12.5, weight: 700, height: 1.4)),
    );
  }
}
