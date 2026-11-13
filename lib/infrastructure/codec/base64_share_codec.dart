import 'dart:convert';

import '../../application/ports/share_codec_port.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/scale.dart';

/// Format `BM1.` + base64url(JSON {n, r, c}), identique à l'ancienne app.
class Base64ShareCodec implements ShareCodecPort {
  Base64ShareCodec({required this.measureCount});
  final int measureCount;

  static const _prefix = 'BM1.';
  static const _notRecognized = 'Ce code n’est pas reconnu. Il doit commencer par BM1.';
  static const _incomplete = 'Ce code est incomplet ou abîmé. Copie-le en entier.';
  static final _validAnswers = RegExp(r'^[0-5-]*$');

  @override
  String encode(String name, Answers answers, Comments comments) {
    final r = StringBuffer();
    final c = <String, String>{};
    for (var id = 0; id < measureCount; id++) {
      r.write(answers[id]?.toString() ?? '-');
      final text = comments[id];
      if (text != null && text.isNotEmpty) c['$id'] = text;
    }
    final json = jsonEncode({'n': name, 'r': r.toString(), 'c': c});
    return _prefix + base64Url.encode(utf8.encode(json)).replaceAll('=', '');
  }

  @override
  Person decode(String code) {
    final clean = code.trim().replaceAll(RegExp(r'\s+'), '');
    if (!clean.startsWith(_prefix)) throw const ShareCodeException(_notRecognized);
    final Object? o;
    try {
      final body = clean.substring(_prefix.length);
      o = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(body))));
    } catch (_) {
      throw const ShareCodeException(_incomplete);
    }
    if (o is! Map || o['r'] is! String) throw const ShareCodeException(_incomplete);
    final r = o['r'] as String;
    if (r.length > measureCount || !_validAnswers.hasMatch(r)) {
      throw const ShareCodeException(_incomplete);
    }
    final answers = <int, int>{};
    for (var i = 0; i < r.length; i++) {
      if (r[i] != '-') answers[i] = int.parse(r[i]);
    }
    final comments = <int, String>{};
    final c = o['c'];
    if (c is Map) {
      c.forEach((k, v) {
        final id = int.tryParse('$k');
        if (id != null && id >= 0 && id < measureCount && v is String) {
          comments[id] = v.length > 500 ? v.substring(0, 500) : v;
        }
      });
    }
    final n = o['n'];
    final name = n is String && n.trim().isNotEmpty
        ? (n.trim().length > 40 ? n.trim().substring(0, 40) : n.trim())
        : 'Sans nom';
    return Person(name: name, answers: answers, comments: comments);
  }
}
