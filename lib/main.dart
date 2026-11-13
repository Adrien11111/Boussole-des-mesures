import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/state/app_state.dart';
import 'infrastructure/catalog/asset_catalog.dart';
import 'infrastructure/clipboard/flutter_clipboard.dart';
import 'infrastructure/codec/base64_share_codec.dart';
import 'infrastructure/storage/prefs_storage.dart';
import 'presentation/state/providers.dart';

/// Composition root : seul endroit qui connaît les implémentations concrètes.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = PrefsStorage(await SharedPreferences.getInstance());
  final catalog = await AssetCatalog().load();
  final initial = await storage.load() ?? AppState.initial();
  runApp(ProviderScope(
    overrides: [
      storageProvider.overrideWithValue(storage),
      clipboardProvider.overrideWithValue(FlutterClipboard()),
      codecProvider.overrideWithValue(Base64ShareCodec(measureCount: catalog.measures.length)),
      catalogProvider.overrideWithValue(catalog),
      initialStateProvider.overrideWithValue(initial),
    ],
    child: const BoussoleApp(),
  ));
}
