import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Petite étiquette en capitales (thème, « Mesure phare »).
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.outlined = false});
  final String text;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final label = Text(text.toUpperCase(),
        style: bodyStyle(outlined ? t.ink : t.muted, outlined ? 12 : 12.8, weight: outlined ? 700 : 600)
            .copyWith(letterSpacing: .5));
    if (!outlined) return label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
      decoration: BoxDecoration(border: Border.all(color: t.ink), borderRadius: BorderRadius.circular(99)),
      child: label,
    );
  }
}
