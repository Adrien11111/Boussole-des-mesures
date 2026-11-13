class ScaleLevel {
  const ScaleLevel(this.value, this.label, this.weight);
  final int value;
  final String label;
  final int? weight;
}

const List<ScaleLevel> scale = [
  ScaleLevel(0, 'Pas d’accord', 0),
  ScaleLevel(1, 'Plutôt pas d’accord', 25),
  ScaleLevel(2, 'Sans avis', null),
  ScaleLevel(3, 'Neutre', 50),
  ScaleLevel(4, 'Plutôt d’accord', 75),
  ScaleLevel(5, 'D’accord', 100),
];

/// Niveaux affichés dans le rail de réponse (touches 1 à 5).
const List<int> rail = [0, 1, 3, 4, 5];

typedef Answers = Map<int, int>;
typedef Comments = Map<int, String>;

bool isRated(int? v) => v != null && v != 2;
