import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'application/state/app_state.dart';
import 'presentation/design_system/app_theme.dart';
import 'presentation/pages/page_for.dart' as pages;
import 'presentation/router.dart';
import 'presentation/state/providers.dart';

class BoussoleApp extends ConsumerStatefulWidget {
  const BoussoleApp({super.key, this.pageFor = pages.pageFor, this.themeBuilder = buildTheme});
  final Widget Function(AppView view) pageFor;
  final ThemeData Function(Brightness) themeBuilder;

  @override
  ConsumerState<BoussoleApp> createState() => _BoussoleAppState();
}

class _BoussoleAppState extends ConsumerState<BoussoleApp> {
  late final GoRouter _router = buildRouter(widget.pageFor);

  @override
  void initState() {
    super.initState();
    // Bouton « retour » du navigateur / de l'OS : le chemin pilote la vue.
    _router.routerDelegate.addListener(() {
      final view = viewForPath(_router.routerDelegate.currentConfiguration.uri.path);
      final ctrl = ref.read(appControllerProvider.notifier);
      if (ref.read(appControllerProvider).view != view) ctrl.goTo(view);
    });
    // Vue pilotée par l'état (ex. fin du quiz) : le routeur suit.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncRouter(ref.read(appControllerProvider).view));
  }

  void _syncRouter(AppView view) {
    final path = viewPaths[view]!;
    if (_router.routerDelegate.currentConfiguration.uri.path != path) _router.go(path);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appControllerProvider.select((s) => s.view), (_, v) => _syncRouter(v));
    final pref = ref.watch(appControllerProvider.select((s) => s.theme));
    final tb = widget.themeBuilder;
    return MaterialApp.router(
      title: 'Boussole des mesures',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      themeMode: switch (pref) {
        ThemePref.light => ThemeMode.light,
        ThemePref.dark => ThemeMode.dark,
        ThemePref.auto => ThemeMode.system,
      },
      theme: tb(Brightness.light),
      darkTheme: tb(Brightness.dark),
    );
  }
}
