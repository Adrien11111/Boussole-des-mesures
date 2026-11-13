import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/design_system/app_theme.dart';
import 'package:boussole/presentation/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../application/fakes.dart';
import 'app_controller_test.dart' show FakeClipboard, FakeStorage;

class Harness {
  Harness(this.container);
  final ProviderContainer container;
  AppState get state => container.read(appControllerProvider);
}

/// Monte [page] avec des faux adaptateurs et le catalogue de test (3 mesures).
Future<Harness> pumpPage(WidgetTester t, Widget page,
    {AppState? initial, Size size = const Size(900, 3000), double textScale = 1}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  final c = ProviderContainer(overrides: [
    storageProvider.overrideWithValue(FakeStorage()),
    clipboardProvider.overrideWithValue(FakeClipboard()),
    codecProvider.overrideWithValue(FakeCodec()),
    catalogProvider.overrideWithValue(testCatalog),
    initialStateProvider.overrideWithValue(initial ?? AppState.initial()),
  ]);
  addTearDown(c.dispose);
  await t.pumpWidget(UncontrolledProviderScope(
    container: c,
    child: MaterialApp(
      theme: buildTheme(Brightness.light),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: page,
    ),
  ));
  await t.pumpAndSettle();
  return Harness(c);
}
