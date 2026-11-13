import 'package:boussole/presentation/router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<GoRouterHandle> pumpAt(WidgetTester t, String path) async {
    t.binding.platformDispatcher.defaultRouteNameTestValue = path;
    addTearDown(t.binding.platformDispatcher.clearDefaultRouteNameTestValue);
    final router = buildRouter((v) => Text(v.name, textDirection: TextDirection.ltr));
    addTearDown(router.dispose);
    await t.pumpWidget(WidgetsApp.router(
      routerConfig: router,
      color: const Color(0xFF000000),
    ));
    await t.pumpAndSettle();
    return GoRouterHandle(router.routerDelegate.currentConfiguration.uri.toString());
  }

  testWidgets('an unknown URL lands on the home page with a clean URL', (t) async {
    final h = await pumpAt(t, '/does-not-exist?x=1');
    expect(find.text('home'), findsOneWidget);
    expect(h.uri, '/');
  });

  testWidgets('a nested unknown URL also returns home', (t) async {
    final h = await pumpAt(t, '/report/oops/deeper');
    expect(find.text('home'), findsOneWidget);
    expect(h.uri, '/');
  });

  testWidgets('known URLs are left alone', (t) async {
    final h = await pumpAt(t, '/compare');
    expect(find.text('compare'), findsOneWidget);
    expect(h.uri, '/compare');
  });
}

class GoRouterHandle {
  GoRouterHandle(this.uri);
  final String uri;
}
