import 'package:boussole/presentation/atoms/pill.dart';
import 'package:boussole/presentation/atoms/progress_bar.dart';
import 'package:boussole/presentation/design_system/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {Brightness b = Brightness.light}) =>
    MaterialApp(theme: buildTheme(b), home: Scaffold(body: child));

void main() {
  testWidgets('Pill(null) reads Passée', (t) async {
    await t.pumpWidget(host(const Pill(null)));
    expect(find.text('Passée'), findsOneWidget);
  });
  testWidgets('Pill(5) reads D’accord, Pill(2) reads Sans avis', (t) async {
    await t.pumpWidget(host(const Column(children: [Pill(5), Pill(2)])));
    expect(find.text('D’accord'), findsOneWidget);
    expect(find.text('Sans avis'), findsOneWidget);
  });
  testWidgets('ProgressBar exposes its value to accessibility', (t) async {
    final h = t.ensureSemantics();
    await t.pumpWidget(host(const ProgressBar(value: 3, max: 10)));
    expect(find.bySemanticsLabel('Progression'), findsOneWidget);
    h.dispose();
  });
  testWidgets('theme tokens differ between light and dark', (t) async {
    expect(buildTheme(Brightness.light).scaffoldBackgroundColor, const Color(0xFFEDF0F4));
    expect(buildTheme(Brightness.dark).scaffoldBackgroundColor, const Color(0xFF0F1620));
  });
}
