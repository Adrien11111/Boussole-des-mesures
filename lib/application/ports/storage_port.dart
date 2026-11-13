import '../state/app_state.dart';

abstract class StoragePort {
  /// null si rien n'est stocké ou si le stockage est illisible.
  Future<AppState?> load();
  Future<void> save(AppState state);
}
