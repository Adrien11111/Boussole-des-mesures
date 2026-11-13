import 'package:boussole/application/ports/catalog_port.dart';
import 'package:boussole/application/ports/share_codec_port.dart';
import 'package:boussole/domain/entities/measure.dart';
import 'package:boussole/domain/entities/person.dart';
import 'package:boussole/domain/entities/scale.dart';
import 'package:boussole/domain/entities/theme_info.dart';

/// 3 mesures : id0 phare (eco), id1 non phare (eco), id2 phare (ins).
final testCatalog = Catalog(
  themes: const [ThemeInfo('eco', 'Économie'), ThemeInfo('ins', 'Institutions')],
  measures: const [
    Measure(id: 0, no: 1, theme: 'eco', text: 'A', phare: true, info: ''),
    Measure(id: 1, no: 2, theme: 'eco', text: 'B', phare: false, info: ''),
    Measure(id: 2, no: 3, theme: 'ins', text: 'C', phare: true, info: ''),
  ],
);

/// Code factice : « BM1. » suivi du prénom.
class FakeCodec implements ShareCodecPort {
  @override
  String encode(String name, Answers a, Comments c) => 'BM1.$name';
  @override
  Person decode(String code) {
    final c = code.trim().replaceAll(RegExp(r'\s+'), '');
    if (!c.startsWith('BM1.')) {
      throw const ShareCodeException('Ce code n’est pas reconnu. Il doit commencer par BM1.');
    }
    return Person(name: c.substring(4), answers: const {}, comments: const {});
  }
}
