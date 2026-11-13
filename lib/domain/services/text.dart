/// Tronque à [max] unités UTF-16 sans couper une paire de substitution (emoji).
String truncateText(String s, int max) {
  if (s.length <= max) return s;
  var end = max;
  final last = s.codeUnitAt(end - 1);
  if (last >= 0xD800 && last <= 0xDBFF) end--; // moitié haute orpheline
  return s.substring(0, end);
}
