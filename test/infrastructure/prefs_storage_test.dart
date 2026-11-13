import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/infrastructure/storage/prefs_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  rangeTests();
  test('save then load returns the same state', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = PrefsStorage(await SharedPreferences.getInstance());
    final s = AppState.initial().copyWith(
      theme: ThemePref.dark,
      openInfo: true,
      name: 'Léa',
      mode: QuizMode.full,
      answers: {0: 5, 7: 2},
      comments: {7: 'hm'},
      pos: {QuizMode.short: 3, QuizMode.full: 9},
      others: ['BM1.abc'],
    );
    await storage.save(s);
    final r = (await storage.load())!;
    expect(r.theme, ThemePref.dark);
    expect(r.openInfo, isTrue);
    expect(r.name, 'Léa');
    expect(r.mode, QuizMode.full);
    expect(r.answers, {0: 5, 7: 2});
    expect(r.comments, {7: 'hm'});
    expect(r.pos, {QuizMode.short: 3, QuizMode.full: 9});
    expect(r.others, ['BM1.abc']);
    expect(r.view, AppView.home);
  });

  test('uses the legacy key and reads the legacy format', () async {
    SharedPreferences.setMockInitialValues({
      'boussole-mesures-v1':
          '{"theme":"light","openInfo":false,"name":"Tom","mode":"short","answers":{"0":5},"comments":{},"pos":{"short":1,"full":0},"others":[{"code":"BM1.zz"}]}'
    });
    final r = (await PrefsStorage(await SharedPreferences.getInstance()).load())!;
    expect(r.name, 'Tom');
    expect(r.answers, {0: 5});
    expect(r.others, ['BM1.zz']);
    expect(r.theme, ThemePref.light);
  });

  test('returns null on missing or corrupted data instead of throwing', () async {
    for (final raw in [null, '{{', '[1,2]']) {
      SharedPreferences.setMockInitialValues(
          raw == null ? {} : {'boussole-mesures-v1': raw});
      final s = PrefsStorage(await SharedPreferences.getInstance());
      expect(await s.load(), isNull, reason: '\$raw');
    }
  });
}

void rangeTests() {
  test('out-of-range answer values are dropped instead of crashing later', () async {
    SharedPreferences.setMockInitialValues({
      'boussole-mesures-v1': '{"name":"Léa","answers":{"0":9,"1":-1,"2":4},"others":[{"code":"BM1.zz"}]}'
    });
    final r = (await PrefsStorage(await SharedPreferences.getInstance()).load())!;
    expect(r.answers, {2: 4});
    expect(r.name, 'Léa');
    expect(r.others, ['BM1.zz']);
  });
  test('a fully invalid answers map keeps the rest of the state', () async {
    SharedPreferences.setMockInitialValues({
      'boussole-mesures-v1': '{"name":"Tom","answers":{"x":"y"}}'
    });
    final r = (await PrefsStorage(await SharedPreferences.getInstance()).load())!;
    expect(r.name, 'Tom');
    expect(r.answers, isEmpty);
  });
}
