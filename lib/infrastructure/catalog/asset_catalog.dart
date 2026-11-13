import 'dart:convert';

import 'package:flutter/services.dart';

import '../../application/ports/catalog_port.dart';
import '../../domain/entities/measure.dart';
import '../../domain/entities/theme_info.dart';

class AssetCatalog implements CatalogPort {
  AssetCatalog({this.bundle, this.path = 'assets/measures.json'});
  final AssetBundle? bundle;
  final String path;

  @override
  Future<Catalog> load() async {
    final raw = await (bundle ?? rootBundle).loadString(path);
    final o = jsonDecode(raw) as Map<String, dynamic>;
    return Catalog(
      themes: [for (final t in o['themes'] as List) ThemeInfo(t['id'] as String, t['name'] as String)],
      measures: [
        for (final m in o['measures'] as List)
          Measure(
            id: m['id'] as int,
            no: m['no'] as int,
            theme: m['theme'] as String,
            text: m['text'] as String,
            phare: m['phare'] as bool,
            info: m['info'] as String,
          ),
      ],
    );
  }
}
