import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildTheme(Brightness brightness) {
  final t = brightness == Brightness.dark ? AppTokens.dark : AppTokens.light;
  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: t.bg,
    canvasColor: t.bg,
    fontFamily: bodyFont,
    colorScheme: ColorScheme.fromSeed(seedColor: t.s5, brightness: brightness)
        .copyWith(primary: t.ink, onPrimary: t.surface, surface: t.surface, onSurface: t.ink),
    textTheme: ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: bodyFont, bodyColor: t.ink, displayColor: t.ink),
    focusColor: t.s5,
    extensions: [t],
  );
}
