import 'package:flutter/material.dart';

const displayFont = 'Bricolage Grotesque';
const bodyFont = 'Instrument Sans';

/// Largeur maximale de la colonne de contenu.
const double contentMaxWidth = 760;
/// Seuil à partir duquel le rail de réponse passe en 5 colonnes.
const double wideBreakpoint = 640;

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.soft,
    required this.s0,
    required this.s1,
    required this.s3,
    required this.s4,
    required this.s5,
  });

  final Color bg, surface, ink, muted, line, soft, s0, s1, s3, s4, s5;

  static const light = AppTokens(
    bg: Color(0xFFEDF0F4), surface: Color(0xFFFFFFFF), ink: Color(0xFF14202E),
    muted: Color(0xFF5B6878), line: Color(0xFFD3D9E2), soft: Color(0xFFF5F7FA),
    s0: Color(0xFFC2410C), s1: Color(0xFFE0834A), s3: Color(0xFF7C8797),
    s4: Color(0xFF4F86D9), s5: Color(0xFF1E4FD8),
  );

  static const dark = AppTokens(
    bg: Color(0xFF0F1620), surface: Color(0xFF18212D), ink: Color(0xFFE8EDF3),
    muted: Color(0xFF9AA7B8), line: Color(0xFF2A3544), soft: Color(0xFF131B26),
    s0: Color(0xFFF0753A), s1: Color(0xFFF0A877), s3: Color(0xFF8B97A8),
    s4: Color(0xFF6FA2F0), s5: Color(0xFF4C84F2),
  );

  static AppTokens of(BuildContext c) => Theme.of(c).extension<AppTokens>()!;

  /// Couleur d'une réponse : 0→s0, 1→s1, 2→muted, 3→s3, 4→s4, 5→s5.
  Color answerColor(int v) => [s0, s1, muted, s3, s4, s5][v];

  /// Texte posé sur la couleur d'une réponse sélectionnée.
  Color onAnswer(int v) => v == 1 ? const Color(0xFF1A1208) : Colors.white;

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) => this;
}

TextStyle displayStyle(Color color, double size, {double weight = 700, double height = 1.1}) =>
    TextStyle(
      fontFamily: displayFont,
      fontFamilyFallback: const [bodyFont], // glyphes absents : police embarquée, jamais le réseau
      fontSize: size,
      height: height,
      color: color,
      letterSpacing: -0.01 * size,
      fontWeight: FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)],
      fontVariations: [FontVariation('wght', weight)],
    );

TextStyle bodyStyle(Color color, double size, {double weight = 400, double height = 1.5}) =>
    TextStyle(
      fontFamily: bodyFont,
      fontFamilyFallback: const [displayFont], // ex. « ² » absent d'Instrument Sans
      fontSize: size,
      height: height,
      color: color,
      fontWeight: FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)],
      fontVariations: [FontVariation('wght', weight)],
    );
