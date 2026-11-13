import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class ModeCard extends StatelessWidget {
  const ModeCard({
    super.key,
    required this.title,
    required this.count,
    required this.countKey,
    required this.description,
    required this.duration,
    required this.onTap,
  });
  final String title, description, duration;
  final int count;
  final Key countKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      button: true,
      child: Material(
        color: t.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), side: BorderSide(color: t.line)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title.toUpperCase(), semanticsLabel: title,
                  style: bodyStyle(t.muted, 12.8, weight: 600).copyWith(letterSpacing: .5)),
              const SizedBox(height: 6),
              Text('$count', key: countKey,
                  style: displayStyle(t.ink, 35, height: 1)
                      .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              const SizedBox(height: 6),
              Text(description, style: bodyStyle(t.ink, 16)),
              const SizedBox(height: 6),
              Text(duration, style: bodyStyle(t.muted, 14)),
              const SizedBox(height: 6),
              Text('Commencer →', style: bodyStyle(t.ink, 16, weight: 600)),
            ]),
          ),
        ),
      ),
    );
  }
}
