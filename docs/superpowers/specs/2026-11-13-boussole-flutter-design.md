# Boussole des mesures — réécriture Flutter (design)

## Intention
Réécrire l'app web mono-fichier (`index.html`, 949 lignes) en Flutter, multi-plateforme (web, iOS, Android, macOS, Windows, Linux), avec clean architecture et atomic design. Objectif : base maintenable et testable, mêmes fonctionnalités et même comportement.

## Goals
- Parité fonctionnelle : accueil, questionnaire (court/complet), rapport, comparaison, thème auto/clair/sombre, raccourcis clavier, commentaires, code de partage.
- Compatibilité : textes FR, format de code `BM1.`, clé de stockage `boussole-mesures-v1`.
- Domaine et application testables sans Flutter.

## Non-goals
Pas de backend, pas de nouvelles fonctionnalités, pas de refonte visuelle.

## Contraintes
- Mac de dev : web, macOS, iOS, Android buildables ; Windows/Linux configurés mais non testés.
- Prod web servie par nginx avec CSP stricte (à adapter à CanvasKit : `wasm-unsafe-eval`).

## Approches considérées
1. React/Vite (abandonnée : l'utilisateur veut des apps natives).
2. **Flutter, clean architecture + Riverpod (retenue)**.
3. Flutter avec Bloc : plus verbeux, aucun gain ici.

## Architecture
`lib/domain` (entités, services purs) → `lib/application` (ports, usecases) → `lib/infrastructure` (shared_preferences, codec BM1, clipboard, catalogue JSON) → `lib/presentation` (design_system, atoms, molecules, organisms, templates, pages, state Riverpod). Composition root dans `main.dart`. Dépendances vers l'intérieur uniquement.

## Choix du builder (mes appels)
Riverpod, go_router, CustomPainter pour jauge/barres, polices embarquées, colonne 760 px sur grand écran, raccourcis clavier sur desktop/web, ancien `index.html` conservé dans `legacy/`, Docker multi-stage Flutter web → nginx.

## Tâches
1. flutter create (6 plateformes), dépendances, structure
2. Extraction des données → assets/measures.json
3. Domaine + tests
4. Application (ports, usecases) + tests
5. Infrastructure (storage, codec BM1, clipboard)
6. Design system, atoms, molecules
7. Organisms, template, pages, navigation, clavier
8. Docker/nginx, README, Makefile
9. Vérification (analyze, tests, builds web/macOS)
