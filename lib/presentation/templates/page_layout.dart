import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/app_state.dart';
import '../design_system/tokens.dart';
import '../organisms/topbar.dart';
import '../state/providers.dart';

/// Gabarit commun : barre du haut + colonne centrée (≤ 760 px) avec 20 px d'écart.
class PageLayout extends ConsumerStatefulWidget {
  const PageLayout({
    super.key,
    required this.view,
    required this.children,
    this.scrollResetKey,
  });
  final AppView view;
  final List<Widget> children;

  /// Quand cette valeur change, la page remonte en haut.
  final Object? scrollResetKey;

  @override
  ConsumerState<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends ConsumerState<PageLayout> {
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(PageLayout old) {
    super.didUpdateWidget(old);
    if (old.scrollResetKey != widget.scrollResetKey && _scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appControllerProvider.notifier);
    final theme = ref.watch(appControllerProvider.select((s) => s.theme));
    final t = AppTokens.of(context);
    // Retour système (Android) : depuis une sous-page on revient à l'accueil ; sur l'accueil on quitte.
    return PopScope(
      canPop: widget.view == AppView.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ctrl.goTo(AppView.home);
      },
      child: Scaffold(
        backgroundColor: t.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scroll,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: contentMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Topbar(
                        view: widget.view,
                        themePref: theme,
                        onNavigate: ctrl.goTo,
                        onToggleTheme: ctrl.cycleTheme,
                      ),
                      for (final c in widget.children) ...[
                        const SizedBox(height: 20),
                        c,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
