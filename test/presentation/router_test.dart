import 'package:boussole/app.dart';
import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/state/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../application/fakes.dart';
import 'app_controller_test.dart' show FakeStorage, FakeClipboard;

void main() {
  testWidgets('the router follows the view held in the controller state', (tester) async {
    final c = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(FakeStorage()),
      clipboardProvider.overrideWithValue(FakeClipboard()),
      codecProvider.overrideWithValue(FakeCodec()),
      catalogProvider.overrideWithValue(testCatalog),
    ]);
    addTearDown(c.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: c, child: BoussoleApp(pageFor: (v) => Text(v.name, textDirection: TextDirection.ltr))));
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    c.read(appControllerProvider.notifier).goTo(AppView.report);
    await tester.pumpAndSettle();
    expect(find.text('report'), findsOneWidget);
  });
}
