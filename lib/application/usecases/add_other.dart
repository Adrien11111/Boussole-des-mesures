import '../ports/share_codec_port.dart';
import '../state/app_state.dart';

/// Valide le code (lève [ShareCodeException]), le normalise, et remplace
/// l'entrée existante portant le même prénom.
AppState addOther(AppState s, ShareCodecPort codec, String rawCode) {
  final person = codec.decode(rawCode);
  final code = rawCode.trim().replaceAll(RegExp(r'\s+'), '');
  final others = List<String>.of(s.others);
  var at = -1;
  for (var k = 0; k < others.length; k++) {
    try {
      if (codec.decode(others[k]).name == person.name) at = k;
    } on ShareCodeException {
      // code stocké illisible : ignoré
    }
  }
  if (at >= 0) {
    others[at] = code;
  } else {
    others.add(code);
  }
  return s.copyWith(others: others);
}
