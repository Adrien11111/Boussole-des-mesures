import 'package:flutter/material.dart';

import '../../application/state/app_state.dart';
import '../atoms/chip_button.dart';
import '../atoms/logo.dart';
import '../design_system/tokens.dart';
import '../molecules/theme_toggle.dart';

class Topbar extends StatelessWidget {
  const Topbar({
    super.key,
    required this.view,
    required this.themePref,
    required this.onNavigate,
    required this.onToggleTheme,
  });
  final AppView view;
  final ThemePref themePref;
  final ValueChanged<AppView> onNavigate;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      spacing: 12,
      children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () => onNavigate(AppView.home),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Logo(color: t.ink),
                const SizedBox(width: 8),
                Flexible(child: Text('Boussole des mesures', style: displayStyle(t.ink, 16.8))),
              ]),
            ),
          ),
        ),
        Wrap(spacing: 6, runSpacing: 6, children: [
          ChipButton(label: 'Noter', current: view == AppView.quiz, onPressed: () => onNavigate(AppView.quiz)),
          ChipButton(label: 'Mon rapport', current: view == AppView.report, onPressed: () => onNavigate(AppView.report)),
          ChipButton(label: 'Comparer', current: view == AppView.compare, onPressed: () => onNavigate(AppView.compare)),
          ThemeToggle(pref: themePref, onPressed: onToggleTheme),
        ]),
      ],
    );
  }
}
