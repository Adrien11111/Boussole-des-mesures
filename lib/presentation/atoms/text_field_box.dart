import 'package:flutter/material.dart';

import '../design_system/tokens.dart';

/// Champ texte avec libellé, aux couleurs de l'app.
class TextFieldBox extends StatelessWidget {
  const TextFieldBox({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.hint,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.mono = false,
  });
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final bool readOnly;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    OutlineInputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.line));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodyStyle(t.ink, 14.4, weight: 600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          readOnly: readOnly,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
          style: mono
              ? TextStyle(fontFamily: 'Menlo', fontFamilyFallback: const ['Consolas', 'monospace'], fontSize: 12.5, color: t.ink)
              : bodyStyle(t.ink, 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: bodyStyle(t.muted, 16),
            filled: true,
            fillColor: t.soft,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: border(),
            border: border(),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.s5, width: 2)),
          ),
        ),
      ],
    );
  }
}
