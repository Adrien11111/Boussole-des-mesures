# Build macOS release en échec : analyse et correction

*Date : 2026-11-13 · Flutter 3.44.7 · Xcode 27.2 · macOS 27*

## Symptôme

`flutter build macos --release` échoue :

```
Target release_unpack_macos failed: Exception: Binary …/FlutterMacOS.framework/Versions/A/FlutterMacOS
does not contain architectures "arm64 x86_64".
Failed to copy Flutter framework.
```

Le build **debug** et les builds web, iOS et Android fonctionnent.

## Cause réelle (diagnostic corrigé)

Mon premier diagnostic (« Xcode 27 ne produit que de l'arm64 ») était **faux**. Ce que j'ai mesuré :

| Vérification | Résultat |
| --- | --- |
| `xcodebuild -showBuildSettings` (Release) | `ARCHS = arm64 x86_64` |
| `lipo -info` du framework produit | `x86_64 arm64` : le binaire **est** universel |
| `clang -arch x86_64` | produit bien un exécutable x86_64 |
| `lipo <bin> -verify_arch arm64 x86_64` | **échoue** : « -verify_arch requires exactly one input file » |
| `lipo <bin> -verify_arch arm64` puis `… x86_64` (deux appels) | réussissent |

Flutter 3.44.7 (`packages/flutter_tools/lib/src/build_system/targets/darwin.dart`, `thinFramework`) lance
`lipo <binaire> -verify_arch arm64 x86_64`. Le `lipo` d'Xcode 27 n'accepte plus qu'**une seule architecture par appel**.
La commande sort en erreur et Flutter la traduit en un message trompeur (« ne contient pas les architectures »).
C'est une incompatibilité Flutter ↔ Xcode 27, pas un problème de ton projet.

## Correctif amont

Sur la branche `master` de Flutter, la vérification se fait désormais **une architecture par appel**
(`lipo <binaire> -verify_arch <arch>`). La dernière version stable est la **3.50.0** (publiée le 2026-11-11).

## Solution recommandée

1. `flutter upgrade` (vers 3.50.0 ou plus récent).
2. `flutter pub get`, puis `flutter build macos --release`.
3. Si `flutter analyze` ou `flutter test` signalent une API modifiée, corriger. Les cibles de déploiement
   (iOS 15, macOS 12) déjà relevées dans ce projet restent valables avec Xcode 27.

**Non vérifié** : je n'ai pas pu lancer le build avec 3.50.0. Le clonage d'un SDK dans un dossier temporaire
a été bloqué par les permissions. La conclusion repose sur la lecture du code amont, pas sur un build réussi.

## Alternatives si tu ne peux pas mettre Flutter à jour

| Option | Statut |
| --- | --- |
| Corriger localement `thinFramework` dans le SDK (une boucle `lipo -verify_arch <arch>` par architecture) | non testée ; écrasée à la prochaine mise à jour |
| Compiler avec une version précédente d'Xcode installée en parallèle (`DEVELOPER_DIR=…`) | non testée |
| Remplacer `lipo` par un script placé dans le `PATH` (un appel par architecture) | **testée, ne marche pas** : le script est correct seul, mais la phase de build d'Xcode ignore le `PATH` du shell, et le réglage `PATH` ajouté dans `Flutter-Release.xcconfig` n'y change rien |
| Distribuer un build debug ou profile | possible pour tester, pas pour diffuser |

## À retenir

- L'échec n'a aucun effet sur le code de l'app : les builds debug de toutes les plateformes passent.
- Après la mise à jour de Flutter, relancer `flutter test` et `flutter analyze` avant de valider.
