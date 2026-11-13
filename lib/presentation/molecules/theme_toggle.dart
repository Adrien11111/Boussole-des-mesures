import 'package:flutter/material.dart';

import '../../application/state/app_state.dart';
import '../atoms/chip_button.dart';

const themeLabels = {
  ThemePref.auto: 'Thème : auto',
  ThemePref.light: 'Thème : clair',
  ThemePref.dark: 'Thème : sombre',
};

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.pref, required this.onPressed});
  final ThemePref pref;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Changer le thème (auto, clair, sombre)',
        child: ChipButton(label: themeLabels[pref]!, onPressed: onPressed),
      );
}
