import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/entities/scale.dart';

/// Raccourcis du questionnaire : 1–5 = réponse, 0 = sans avis, ← → = navigation.
/// Ignorés quand un champ de saisie a le focus.
class QuizShortcuts extends StatefulWidget {
  const QuizShortcuts({super.key, required this.onAnswer, required this.onStep, required this.child});
  final ValueChanged<int> onAnswer;
  final ValueChanged<int> onStep;
  final Widget child;

  @override
  State<QuizShortcuts> createState() => _QuizShortcutsState();
}

class _QuizShortcutsState extends State<QuizShortcuts> {
  static final _digits = <LogicalKeyboardKey, int>{
    LogicalKeyboardKey.digit0: 0, LogicalKeyboardKey.numpad0: 0,
    LogicalKeyboardKey.digit1: 1, LogicalKeyboardKey.numpad1: 1,
    LogicalKeyboardKey.digit2: 2, LogicalKeyboardKey.numpad2: 2,
    LogicalKeyboardKey.digit3: 3, LogicalKeyboardKey.numpad3: 3,
    LogicalKeyboardKey.digit4: 4, LogicalKeyboardKey.numpad4: 4,
    LogicalKeyboardKey.digit5: 5, LogicalKeyboardKey.numpad5: 5,
  };

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _typing() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText || ctx.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return false;
    final k = HardwareKeyboard.instance;
    if (k.isControlPressed || k.isMetaPressed || k.isAltPressed || _typing()) return false;
    final d = _digits[e.logicalKey];
    if (d != null) {
      widget.onAnswer(d == 0 ? 2 : rail[d - 1]);
      return true;
    }
    if (e.logicalKey == LogicalKeyboardKey.arrowRight) {
      widget.onStep(1);
      return true;
    }
    if (e.logicalKey == LogicalKeyboardKey.arrowLeft) {
      widget.onStep(-1);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
