import '../entities/scale.dart';
import '../entities/score.dart';

Score similarity(Answers a, Answers b, int measureCount) {
  var d = 0, n = 0;
  for (var id = 0; id < measureCount; id++) {
    final x = a[id], y = b[id];
    if (isRated(x) && isRated(y)) {
      d += (scale[x!].weight! - scale[y!].weight!).abs();
      n++;
    }
  }
  return n == 0 ? Score.empty : Score((100 - d / n).round(), n);
}
