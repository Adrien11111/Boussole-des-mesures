import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/atoms/app_button.dart';
import 'package:boussole/presentation/organisms/footer_note.dart';
import 'package:boussole/presentation/organisms/gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'atoms_test.dart' show host;

void main() {
  testWidgets('AppButton is a button and exposes its disabled state', (t) async {
    final h = t.ensureSemantics();
    await t.pumpWidget(host(const Column(children: [
      AppButton(label: 'Actif', onPressed: _noop),
      AppButton(label: 'Inactif', onPressed: null),
    ])));
    expect(t.getSemantics(find.text('Actif')), isSemantics(isButton: true, isEnabled: true, hasEnabledState: true, hasTapAction: true));
    expect(t.getSemantics(find.text('Inactif')), isSemantics(isButton: true, isEnabled: false, hasEnabledState: true));
    h.dispose();
  });

  testWidgets('footer link is keyboard-focusable', (t) async {
    await t.pumpWidget(host(const SingleChildScrollView(child: FooterNote(measureCount: 3, pharesCount: 2))));
    final link = find.ancestor(
        of: find.textContaining('programme « L’Avenir en commun »'), matching: find.byType(InkWell));
    expect(link, findsOneWidget);
    expect(t.widget<InkWell>(link).canRequestFocus, isTrue);
  });

  testWidgets('Gauge is announced once, with its caption', (t) async {
    final h = t.ensureSemantics();
    await t.pumpWidget(host(const Gauge(pct: 80, caption: 'sur 3 mesures notées')));
    expect(find.bySemanticsLabel(RegExp('80')), findsOneWidget);
    h.dispose();
  });

  testWidgets('AppState import keeps analyzer honest', (t) async {
    expect(AppState.initial().view, AppView.home);
  });
}

void _noop() {}
