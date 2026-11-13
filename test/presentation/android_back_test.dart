import 'package:boussole/app.dart';
import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/state/providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../application/fakes.dart';
import 'app_controller_test.dart' show FakeClipboard, FakeStorage;

void main() {
  Future<ProviderContainer> start(WidgetTester t, String route) async {
    t.view.physicalSize = const Size(900, 3000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    t.binding.platformDispatcher.defaultRouteNameTestValue = route;
    addTearDown(t.binding.platformDispatcher.clearDefaultRouteNameTestValue);
    final c = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(FakeStorage()),
      clipboardProvider.overrideWithValue(FakeClipboard()),
      codecProvider.overrideWithValue(FakeCodec()),
      catalogProvider.overrideWithValue(testCatalog),
    ]);
    addTearDown(c.dispose);
    await t.pumpWidget(UncontrolledProviderScope(container: c, child: const BoussoleApp()));
    await t.pumpAndSettle();
    return c;
  }

  testWidgets('Android back from a sub-page returns home instead of leaving the app', (t) async {
    final exits = <MethodCall>[];
    t.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemNavigator.pop') exits.add(call);
      return null;
    });
    addTearDown(() => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

    final c = await start(t, '/report');
    expect(c.read(appControllerProvider).view, AppView.report);

    await t.binding.handlePopRoute();
    await t.pumpAndSettle();
    expect(c.read(appControllerProvider).view, AppView.home);
    expect(exits, isEmpty);

    await t.binding.handlePopRoute(); // sur l'accueil : on quitte
    await t.pumpAndSettle();
    expect(exits, hasLength(1));
  });
}
