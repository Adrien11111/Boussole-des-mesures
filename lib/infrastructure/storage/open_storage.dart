import 'package:shared_preferences/shared_preferences.dart';

import '../../application/ports/storage_port.dart';
import 'memory_storage.dart';
import 'prefs_storage.dart';

/// Ouvre le stockage persistant ; sans lui, l'appli marche sans mémoire (comme l'ancienne version).
Future<StoragePort> openStorage(Future<SharedPreferences> Function() open) async {
  try {
    return PrefsStorage(await open());
  } catch (_) {
    return MemoryStorage();
  }
}
