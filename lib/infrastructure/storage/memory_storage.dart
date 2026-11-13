import '../../application/ports/storage_port.dart';
import '../../application/state/app_state.dart';

/// Repli quand le stockage du navigateur / de l'appareil est inutilisable.
class MemoryStorage implements StoragePort {
  AppState? _state;
  @override
  Future<AppState?> load() async => _state;
  @override
  Future<void> save(AppState state) async => _state = state;
}
