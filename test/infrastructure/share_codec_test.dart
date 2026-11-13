import 'dart:convert';
import 'package:boussole/application/ports/share_codec_port.dart';
import 'package:boussole/infrastructure/codec/base64_share_codec.dart';
import 'package:flutter_test/flutter_test.dart';

/// Code produit par l'ancienne app (encodeCode de legacy/index.html) pour
/// name "Léa", réponses {0:5, 1:2, 5:0}, commentaire {0: "ok é"}.
const legacyCode =
    'BM1.eyJuIjoiTMOpYSIsInIiOiI1Mi0tLTAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSIsImMiOnsiMCI6Im9rIMOpIn19';

String b64(Map<String, dynamic> o) =>
    base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');

void main() {
  final codec = Base64ShareCodec(measureCount: 1034);
  const incomplete = 'Ce code est incomplet ou abîmé. Copie-le en entier.';

  test('round-trips name, answers and comments', () {
    final p = codec.decode(codec.encode('Léa', {0: 5, 3: 0}, {0: 'ok'}));
    expect(p.name, 'Léa');
    expect(p.answers, {0: 5, 3: 0});
    expect(p.comments, {0: 'ok'});
  });

  test('decodes a real code produced by the legacy app', () {
    final p = codec.decode(legacyCode);
    expect(p.name, 'Léa');
    expect(p.answers, {0: 5, 1: 2, 5: 0});
    expect(p.comments, {0: 'ok é'});
  });

  test('encodes to exactly what the legacy app produced', () {
    expect(codec.encode('Léa', {0: 5, 1: 2, 5: 0}, {0: 'ok é'}), legacyCode);
  });

  test('accepts spaces and line breaks inside the code', () {
    final spaced = '${legacyCode.substring(0, 30)}\n ${legacyCode.substring(30)}  ';
    expect(codec.decode(spaced).name, 'Léa');
  });

  test('rejects a code without the BM1. prefix', () {
    expect(
        () => codec.decode('XYZ.abc'),
        throwsA(isA<ShareCodeException>().having((e) => e.message, 'message',
            'Ce code n’est pas reconnu. Il doit commencer par BM1.')));
  });

  test('rejects a truncated code', () {
    final cut = legacyCode.substring(0, legacyCode.length ~/ 2);
    expect(() => codec.decode(cut),
        throwsA(isA<ShareCodeException>().having((e) => e.message, 'message', incomplete)));
  });

  test('rejects answers longer than the catalog or with invalid characters', () {
    for (final r in ['0' * 1035, '9', 'a-']) {
      expect(() => codec.decode('BM1.${b64({'n': 'X', 'r': r, 'c': {}})}'),
          throwsA(isA<ShareCodeException>().having((e) => e.message, 'message', incomplete)),
          reason: r);
    }
  });

  test('truncates comments to 500 and names to 40; empty name is Sans nom', () {
    final p = codec.decode(codec.encode('a' * 50, {}, {0: 'x' * 600}));
    expect(p.comments[0]!.length, 500);
    expect(p.name.length, 40);
    expect(codec.decode(codec.encode('', {}, {})).name, 'Sans nom');
  });
}
