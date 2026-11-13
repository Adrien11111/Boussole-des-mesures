typedef SplitInfo = ({String ctx, String pro, String con});

final _full = RegExp(r'^(.*?)\s*Pour ses partisans, (.*?)\s*;\s*pour ses critiques, (.*)$');
final _opponents = RegExp(r'Ses (?:critiques|défenseurs|opposants|détracteurs) ');
final _afterPartisans = RegExp(
    r'^(.*?)\s*[;,]\s*(ses (?:critiques|défenseurs|opposants|détracteurs)\b.*)$');
final _elliptic = RegExp(r'^(ses (?:critiques|défenseurs|opposants|détracteurs)), (.*)$');
final _verb = RegExp(r'^Ses partisans (parlent|y voient)\b');
final _prep = RegExp(r"^(?:d’|de |du |des |d')");
final _trailing = RegExp(r'[.\s]+$');

/// Sépare contexte, avis des partisans et avis des critiques (port du legacy).
SplitInfo? splitInfo(String s) {
  final pf = _full.firstMatch(s);
  if (pf != null) {
    return (
      ctx: pf[1]!.trim(),
      pro: 'Pour ses partisans, ${pf[2]!.replaceAll(_trailing, '')}.',
      con: 'Pour ses critiques, ${pf[3]}',
    );
  }
  final k = s.indexOf('Ses partisans ');
  if (k < 0) {
    final kc = s.indexOf(_opponents);
    if (kc < 0) return null;
    return (ctx: s.substring(0, kc).trim(), pro: '', con: s.substring(kc));
  }
  final rest = s.substring(k);
  final mm = _afterPartisans.firstMatch(rest);
  if (mm == null) return null;
  final pro = '${mm[1]!.replaceAll(_trailing, '')}.';
  var con = mm[2]!;
  final el = _elliptic.firstMatch(con);
  if (el != null) {
    final vb = _verb.firstMatch(pro);
    final obj = el[2]!;
    con = '${el[1]} ${vb != null ? vb[1] : (_prep.hasMatch(obj) ? 'parlent' : 'mettent en avant')} $obj';
  }
  con = con[0].toUpperCase() + con.substring(1);
  return (ctx: s.substring(0, k).trim(), pro: pro, con: con);
}
