import '../ports/catalog_port.dart';
import '../state/app_state.dart';
import 'measure_ids_for.dart';

const maxCommentLength = 500;

AppState setComment(AppState s, Catalog cat, String text) {
  final id = currentMeasureId(s, cat);
  final c = Map<int, String>.of(s.comments);
  if (text.trim().isEmpty) {
    c.remove(id);
  } else {
    c[id] = text.length > maxCommentLength ? text.substring(0, maxCommentLength) : text;
  }
  return s.copyWith(comments: c);
}
