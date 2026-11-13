import 'package:boussole/application/state/app_state.dart';
import 'package:boussole/infrastructure/storage/memory_storage.dart';
import 'package:boussole/infrastructure/storage/open_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('falls back to in-memory storage when preferences cannot be opened', () async {
    final storage = await openStorage(() async => throw Exception('localStorage blocked'));
    expect(storage, isA<MemoryStorage>());
    expect(await storage.load(), isNull);
    await storage.save(AppState.initial().copyWith(name: 'Léa'));
    expect((await storage.load())!.name, 'Léa');
  });
  test('uses persistent storage when available', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await openStorage(SharedPreferences.getInstance);
    expect(storage, isNot(isA<MemoryStorage>()));
  });
}
