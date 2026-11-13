# Boussole des mesures

Application Flutter (web, iOS, Android, macOS, Windows, Linux) pour noter les mesures d'un programme, obtenir un rapport et comparer ses avis avec ceux de ses proches. Les réponses restent sur l'appareil ; elles ne sont partagées que si l'on envoie son code `BM1.…`.

## Architecture

```
lib/
  domain/          règles métier pures (Dart, sans Flutter) : scores, similarité, rapport
  application/     ports (stockage, presse-papiers, codec, catalogue) + cas d'usage
  infrastructure/  adaptateurs : shared_preferences, codec BM1, presse-papiers, catalogue JSON
  presentation/    Flutter + Riverpod, atomic design :
                   design_system/ atoms/ molecules/ organisms/ templates/ pages/ state/
  main.dart        composition root (seul endroit qui connaît les implémentations)
```

Dépendances : `presentation → application → domain` ; `infrastructure` implémente les ports de `application`.
Les données (1034 mesures) sont dans `assets/measures.json` ; l'ancienne version mono-fichier est conservée dans `legacy/`.

## Commandes

| Commande | Effet |
| --- | --- |
| `make dev` | `flutter run -d chrome` (rechargement à chaud) |
| `make test` / `make analyze` | tests / analyse statique |
| `make web` | build web (`build/web`, CanvasKit embarqué, sans requête externe) |
| `make macos` | build macOS |
| `make prod` | image nginx non-root (CSP stricte) sur http://localhost:8080 |
| `make stop` | arrête le conteneur |

Autres plateformes : `flutter run -d ios|android|windows|linux`. Les builds Windows et Linux se font sur ces systèmes (Flutter ne cross-compile pas) ; Android demande d'accepter les licences : `flutter doctor --android-licenses`.

### Linux

`flutter build linux --release` (sur Linux : `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`). L'icône de fenêtre est installée dans le bundle (`data/icons/boussole.png`) et chargée au démarrage.
Pour l'intégrer au lanceur (Wayland/GNOME, menu des applications), installer l'entrée de bureau et l'icône :

```
install -Dm644 linux/packaging/fr.boussole.boussole.desktop ~/.local/share/applications/fr.boussole.boussole.desktop
install -Dm644 linux/packaging/fr.boussole.boussole.png ~/.local/share/icons/hicolor/512x512/apps/fr.boussole.boussole.png
```

Le fichier `.desktop` suppose que l'exécutable `boussole` est dans le `PATH` ; adapter `Exec=` sinon.

### Logo

`python3 tool/make_icon.py` redessine le logo (Pillow), puis `dart run flutter_launcher_icons` décline les icônes web, iOS, Android, macOS et Windows.

Compatibilité : la clé de stockage (`boussole-mesures-v1`) et le format des codes `BM1.` sont ceux de l'ancienne version.
