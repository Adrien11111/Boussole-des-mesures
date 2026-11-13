import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../application/ports/storage_port.dart';
import '../../application/state/app_state.dart';

/// Stockage local, même clé et même format JSON que l'ancienne app.
class PrefsStorage implements StoragePort {
  PrefsStorage(this._prefs);
  final SharedPreferences _prefs;

  static const key = 'boussole-mesures-v1';

  @override
  Future<AppState?> load() async {
    try {
      final raw = _prefs.getString(key);
      if (raw == null) return null;
      final o = jsonDecode(raw);
      if (o is! Map) return null;
      final base = AppState.initial();
      final pos = o['pos'] is Map ? o['pos'] as Map : const {};
      return base.copyWith(
        name: o['name'] is String ? o['name'] as String : '',
        theme: switch (o['theme']) {
          'light' => ThemePref.light,
          'dark' => ThemePref.dark,
          _ => ThemePref.auto,
        },
        openInfo: o['openInfo'] == true,
        mode: o['mode'] == 'full' ? QuizMode.full : QuizMode.short,
        answers: _intMap<int>(o['answers']),
        comments: _intMap<String>(o['comments']),
        pos: {
          QuizMode.short: pos['short'] is int ? pos['short'] as int : 0,
          QuizMode.full: pos['full'] is int ? pos['full'] as int : 0,
        },
        others: o['others'] is List
            ? [
                for (final e in o['others'] as List)
                  if (e is String) e else if (e is Map && e['code'] is String) e['code'] as String
              ]
            : const [],
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(AppState s) async {
    try {
      await _prefs.setString(
        key,
        jsonEncode({
          'theme': s.theme.name,
          'openInfo': s.openInfo,
          'name': s.name,
          'mode': s.mode.name,
          'answers': {for (final e in s.answers.entries) '${e.key}': e.value},
          'comments': {for (final e in s.comments.entries) '${e.key}': e.value},
          'pos': {'short': s.pos[QuizMode.short] ?? 0, 'full': s.pos[QuizMode.full] ?? 0},
          'others': [for (final c in s.others) {'code': c}],
        }),
      );
    } catch (_) {
      // stockage indisponible : l'appli fonctionne sans mémoire
    }
  }

  static Map<int, T> _intMap<T>(Object? v) {
    final out = <int, T>{};
    if (v is Map) {
      v.forEach((k, val) {
        final id = int.tryParse('$k');
        if (id != null && val is T) out[id] = val;
      });
      if (v.isNotEmpty && out.isEmpty) throw const FormatException('bad map');
    }
    return out;
  }
}
