import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.ghost = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      excludeSemantics: true,
      label: label,
      onTap: onPressed,
      child: Opacity(
        opacity: enabled ? 1 : .4,
        child: Material(
          color: ghost ? Colors.transparent : t.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: ghost ? t.line : t.ink),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              child: Text(
                label,
                style: bodyStyle(ghost ? t.ink : t.surface, 16, weight: 600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
