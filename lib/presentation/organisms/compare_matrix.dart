import 'package:flutter/material.dart';

import '../atoms/card_surface.dart';
import '../atoms/heading.dart';
import '../molecules/simple_table.dart';

/// « Tous les duos » : matrice de proximité entre toutes les personnes.
class CompareMatrix extends StatelessWidget {
  const CompareMatrix({super.key, required this.names, required this.cells});
  final List<String> names;
  /// cells[i][j] déjà formaté (« — » sur la diagonale).
  final List<List<String>> cells;

  @override
  Widget build(BuildContext context) => CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Tous les duos'),
          const SizedBox(height: 14),
          SimpleTable(
            headers: ['', ...names],
            rows: [for (var i = 0; i < names.length; i++) [names[i], ...cells[i]]],
          ),
        ]),
      );
}

/// Accord global puis par thème, personne par personne.
class CompareThemeTable extends StatelessWidget {
  const CompareThemeTable({super.key, required this.names, required this.rows});
  final List<String> names;
  /// Première ligne = « Accord global ».
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) => CardSurface(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Accord par thème, personne par personne'),
          const SizedBox(height: 14),
          SimpleTable(headers: ['', ...names], rows: rows, boldRows: const {0}),
        ]),
      );
}
