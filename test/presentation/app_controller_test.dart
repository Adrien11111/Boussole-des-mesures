import 'package:boussole/application/ports/clipboard_port.dart';
import 'package:boussole/application/ports/storage_port.dart';
import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/presentation/state/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../application/fakes.dart';

class FakeStorage implements StoragePort {
  int saves = 0;
  AppState? last;
  @override
  Future<AppState?> load() async => last;
  @override
  Future<void> save(AppState state) async {
    saves++;
    last = state;
  }
}

class FakeClipboard implements ClipboardPort {
  String? text;
  @override
  Future<bool> copy(String t) async {
    text = t;
    return true;
  }
}

void main() {
  late FakeStorage storage;
  late ProviderContainer c;

  setUp(() {
    storage = FakeStorage();
    c = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(storage),
      clipboardProvider.overrideWithValue(FakeClipboard()),
      codecProvider.overrideWithValue(FakeCodec()),
      catalogProvider.overrideWithValue(testCatalog),
      initialStateProvider.overrideWithValue(AppState.initial()),
    ]);
  });
  tearDown(() => c.dispose());

  AppController ctrl() => c.read(appControllerProvider.notifier);
  AppState st() => c.read(appControllerProvider);

  test('answer updates the state and saves exactly once', () {
    ctrl().answer(5);
    expect(st().answers, {0: 5});
    expect(storage.saves, 1);
  });

  test('addOther with an invalid code returns the French error message', () {
    expect(ctrl().addOther('xx'), 'Ce code n’est pas reconnu. Il doit commencer par BM1.');
    expect(st().others, isEmpty);
  });

  test('addOther with a valid code returns null and stores it', () {
    expect(ctrl().addOther('BM1.Léa'), isNull);
    expect(st().others, ['BM1.Léa']);
  });

  test('cycleTheme goes auto → light → dark → auto', () {
    final seen = <ThemePref>[];
    for (var i = 0; i < 3; i++) {
      ctrl().cycleTheme();
      seen.add(st().theme);
    }
    expect(seen, [ThemePref.light, ThemePref.dark, ThemePref.auto]);
  });

  test('next past the last measure opens the report', () {
    ctrl().start(QuizMode.short);
    expect(st().view, AppView.quiz);
    ctrl().next();
    ctrl().next();
    expect(st().view, AppView.report);
  });

  test('setName caps the first name at 40 characters', () {
    ctrl().setName('a' * 50);
    expect(st().name.length, 40);
  });

  test('reset clears everything and returns home', () {
    ctrl().answer(5);
    ctrl().reset();
    expect(st().answers, isEmpty);
    expect(st().view, AppView.home);
  });
}
