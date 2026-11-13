import 'package:boussole/app.dart';
import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/state/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../application/fakes.dart';
import 'app_controller_test.dart' show FakeClipboard, FakeStorage;

void main() {
  testWidgets('reloading on /report adopts the view without a build-time provider write', (t) async {
    t.binding.platformDispatcher.defaultRouteNameTestValue = '/report';
    addTearDown(t.binding.platformDispatcher.clearDefaultRouteNameTestValue);
    final c = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(FakeStorage()),
      clipboardProvider.overrideWithValue(FakeClipboard()),
      codecProvider.overrideWithValue(FakeCodec()),
      catalogProvider.overrideWithValue(testCatalog),
    ]);
    addTearDown(c.dispose);
    await t.pumpWidget(UncontrolledProviderScope(
        container: c,
        child: BoussoleApp(pageFor: (v) => Text(v.name, textDirection: TextDirection.ltr))));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(c.read(appControllerProvider).view, AppView.report);
    expect(find.text('report'), findsOneWidget);
  });
}
