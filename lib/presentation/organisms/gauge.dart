import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Jauge semi-circulaire d'accord global.
class Gauge extends StatelessWidget {
  const Gauge({super.key, required this.pct, required this.caption});
  final int pct;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      label: 'Accord global : $pct pour cent',
      child: Column(children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: AspectRatio(
            aspectRatio: 200 / 112,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Positioned.fill(child: CustomPaint(painter: _GaugePainter(pct, t.line, t.s5))),
              Text('$pct %',
                  style: displayStyle(t.ink, MediaQuery.sizeOf(context).width < 400 ? 52 : 70, height: 1)
                      .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
            ]),
          ),
        ),
        const SizedBox(height: 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(caption, textAlign: TextAlign.center, style: bodyStyle(t.muted, 16)),
        ),
      ]),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter(this.pct, this.track, this.fill);
  final int pct;
  final Color track, fill;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 200;
    final rect = Rect.fromCircle(center: Offset(100 * k, 100 * k), radius: 80 * k);
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16 * k
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, p(track));
    if (pct > 0) canvas.drawArc(rect, math.pi, math.pi * pct / 100, false, p(fill));
  }

  @override
  bool shouldRepaint(_GaugePainter o) => o.pct != pct || o.track != track || o.fill != fill;
}
