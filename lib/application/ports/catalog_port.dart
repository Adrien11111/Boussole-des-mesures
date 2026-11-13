import '../../domain/entities/measure.dart';
import '../../domain/entities/theme_info.dart';

class Catalog {
  const Catalog({required this.themes, required this.measures});
  final List<ThemeInfo> themes;
  final List<Measure> measures;
}

abstract class CatalogPort {
  Future<Catalog> load();
}
