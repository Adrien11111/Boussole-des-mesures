import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../application/state/app_state.dart';

const viewPaths = {
  AppView.home: '/',
  AppView.quiz: '/quiz',
  AppView.report: '/report',
  AppView.compare: '/compare',
};

AppView viewForPath(String path) =>
    viewPaths.entries.firstWhere((e) => e.value == path, orElse: () => viewPaths.entries.first).key;

/// Construit le routeur. [pageFor] fournit l'écran de chaque vue.
GoRouter buildRouter(Widget Function(AppView view) pageFor) => GoRouter(
      routes: [
        for (final e in viewPaths.entries)
          GoRoute(
            path: e.value,
            pageBuilder: (_, _) => NoTransitionPage(key: ValueKey(e.value), child: pageFor(e.key)),
          ),
      ],
    );
