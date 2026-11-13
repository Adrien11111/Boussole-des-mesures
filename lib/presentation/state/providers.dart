import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ports/catalog_port.dart';
import '../../application/ports/clipboard_port.dart';
import '../../application/ports/share_codec_port.dart';
import '../../application/ports/storage_port.dart';
import '../../application/state/app_state.dart';

export 'app_controller.dart';

// Tous surchargés dans la composition root (main.dart) ou dans les tests.
final storageProvider = Provider<StoragePort>((_) => throw UnimplementedError('storageProvider'));
final clipboardProvider = Provider<ClipboardPort>((_) => throw UnimplementedError('clipboardProvider'));
final codecProvider = Provider<ShareCodecPort>((_) => throw UnimplementedError('codecProvider'));
final catalogProvider = Provider<Catalog>((_) => throw UnimplementedError('catalogProvider'));
final initialStateProvider = Provider<AppState>((_) => AppState.initial());
