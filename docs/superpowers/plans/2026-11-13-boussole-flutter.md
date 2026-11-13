# Boussole des mesures — Flutter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Réécrire l'app `index.html` en Flutter (web, iOS, Android, macOS, Windows, Linux) avec clean architecture et atomic design, à fonctionnalités identiques.

**Architecture:** `domain` (Dart pur) ← `application` (ports + usecases) ← `infrastructure` (adaptateurs) ; `presentation` (Flutter, atomic design, Riverpod) consomme `application`. Composition root dans `lib/main.dart`.

**Tech Stack:** Flutter 3.44 stable / Dart 3, flutter_riverpod, go_router, shared_preferences, flutter_test, nginx (web prod).

**Spec:** `docs/superpowers/specs/2026-11-13-boussole-flutter-design.md`

## Global Constraints

- Projet Flutter à la racine `/Users/apanis/Downloads/boussole-docker`, nom de package `boussole`, org `fr.boussole`, plateformes : `web,ios,android,macos,windows,linux`.
- Dépendances inward only : `domain` n'importe rien hors `dart:*` ; `application` importe seulement `domain` ; `infrastructure` importe `application`+`domain` ; `presentation` n'importe jamais `infrastructure` (sauf `main.dart`/`composition`).
- Clé de stockage : `boussole-mesures-v1` ; format de code de partage : préfixe `BM1.` + base64url sans padding du JSON `{n, r, c}` (`r` = un caractère par mesure, `0-5` ou `-`).
- Données : **1034** mesures au total, **48** phares (6 par thème × 8), 8 thèmes dans l'ordre `eco, ins, clim, eur, san, edu, sec, imm`. L'ordre d'import (DATA P puis O, puis EXTRA, puis EXTRA2, par thème) donne l'`id` et ne doit pas changer ; `no` provient du tableau `NUM`.
- Échelle : 0 Pas d'accord (0 %), 1 Plutôt pas d'accord (25), 2 Sans avis (exclu du calcul), 3 Neutre (50), 4 Plutôt d'accord (75), 5 D'accord (100). Rail affiché : `[0,1,3,4,5]`, touches 1–5 ; touche 0 = Sans avis.
- Textes UI en français, identiques à `legacy/index.html`. Prénom ≤ 40 car., commentaire ≤ 500 car.
- Couleurs claires : bg `#EDF0F4`, surface `#FFFFFF`, ink `#14202E`, muted `#5B6878`, line `#D3D9E2`, soft `#F5F7FA`, s0 `#C2410C`, s1 `#E0834A`, s3 `#7C8797`, s4 `#4F86D9`, s5 `#1E4FD8`. Sombres : bg `#0F1620`, surface `#18212D`, ink `#E8EDF3`, muted `#9AA7B8`, line `#2A3544`, soft `#131B26`, s0 `#F0753A`, s1 `#F0A877`, s3 `#8B97A8`, s4 `#6FA2F0`, s5 `#4C84F2`.
- Polices embarquées en assets (Bricolage Grotesque, Instrument Sans) ; aucune requête réseau à l'exécution. Colonne de contenu max 760 px.
- `git` n'est pas initialisé : les étapes « Commit » font `git init` à la première tâche, puis commit avec le trailer `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.

## Review Focus

- Code `BM1.` collé avec espaces/retours à la ligne, tronqué, ou préfixe absent → message d'erreur FR exact de l'ancienne app, sans crash (Task 5).
- `r` plus long que 1034 caractères ou contenant autre chose que `[0-5-]` → rejeté ; commentaires >500 car. tronqués (Task 5).
- Aucune mesure notée (ou uniquement « Sans avis ») → score `null` affiché « — », pas de division par zéro (Task 3).
- localStorage/SharedPreferences corrompu ou JSON invalide → l'app démarre avec l'état par défaut (Task 5).
- Comparaison : deux personnes sans mesure commune → « — », pas de crash ; même prénom ré-importé → remplace au lieu de dupliquer (Tasks 3, 4).
- Raccourcis clavier ignorés quand un champ texte a le focus (Task 8).

---

### Task 1: Initialiser le projet Flutter

**Files:**
- Create: projet Flutter complet (`pubspec.yaml`, `lib/`, `test/`, dossiers de plateformes) ; `.gitignore`
- Move: `index.html` → `legacy/index.html`
- Modify: `pubspec.yaml`, `analysis_options.yaml`

**Interfaces:** Produces: structure `lib/{domain,application,infrastructure,presentation}` vide ; dépendances installées.

- [ ] **Step 1:** `git init`, puis `mkdir legacy && mv index.html legacy/` (le Dockerfile sera refait en Task 9).
- [ ] **Step 2:** `flutter create . --project-name boussole --org fr.boussole --platforms web,ios,android,macos,windows,linux` ; supprimer le `test/widget_test.dart` généré.
- [ ] **Step 3:** `flutter pub add flutter_riverpod go_router shared_preferences` ; `flutter pub add --dev flutter_lints`. Créer les 4 dossiers de couches.
- [ ] **Step 4:** Écrire `test/smoke_test.dart` (`expect(1+1, 2)`) ; Run: `flutter test` → PASS ; `flutter analyze` → « No issues found ».
- [ ] **Step 5: Commit** — `chore: scaffold flutter project (6 platforms)`.

### Task 2: Extraire le catalogue de mesures en JSON

**Files:**
- Create: `tool/extract_catalog.js` (script one-shot, lit `legacy/index.html`), `assets/measures.json`, `test/infrastructure/catalog_asset_test.dart`
- Modify: `pubspec.yaml` (déclarer `assets/measures.json`)

**Interfaces:** Produces: `assets/measures.json` de forme `{"themes":[{"id","name"}], "measures":[{"id":int,"no":int,"theme":String,"text":String,"phare":bool,"info":String}]}` dans l'ordre d'id.

- [ ] **Step 1: Write the failing test** `catalog_asset_test.dart` : lit le fichier JSON ; `measures.length == 1034`, `measures.where(phare).length == 48`, `themes.map(id) == [eco,ins,clim,eur,san,edu,sec,imm]`, ids = 0..1033 contigus, `measures[0].no == 1`, `measures[0].text` commence par « Construire 200 000 logements publics ».
- [ ] **Step 2:** Run `flutter test test/infrastructure/catalog_asset_test.dart` → FAIL (fichier absent).
- [ ] **Step 3:** Implémenter `tool/extract_catalog.js` : extrait le bloc `<script>` jusqu'à `//#logic-end`, l'évalue avec `new Function`, sérialise `M` et `THEMES` dans `assets/measures.json`. Lancer `node tool/extract_catalog.js`.
- [ ] **Step 4:** Run le test → PASS.
- [ ] **Step 5: Commit** — `feat: extract measures catalog to JSON`.

### Task 3: Domaine — entités et services purs

**Files:**
- Create: `lib/domain/entities/{scale.dart,measure.dart,theme_info.dart,person.dart,score.dart}`, `lib/domain/services/{scoring.dart,similarity.dart,info_splitter.dart,report_builder.dart}`
- Test: `test/domain/{scoring_test.dart,similarity_test.dart,info_splitter_test.dart,report_builder_test.dart}`

**Interfaces:** Produces (tous purs, `typedef Answers = Map<int,int>`, `typedef Comments = Map<int,String>`) :
- `class ScaleLevel { final int value; final String label; final int? weight; }` ; `const List<ScaleLevel> scale` (6 niveaux ci-dessus) ; `const List<int> rail = [0,1,3,4,5]` ; `bool isRated(int? v)` (non-null et ≠ 2).
- `class Measure { int id; int no; String theme; String text; bool phare; String info; }`, `class ThemeInfo { String id; String name; }`.
- `class Person { String name; Answers answers; Comments comments; }`.
- `class Score { final int? pct; final int n; }`.
- `Score score(Iterable<int> ids, Answers a)` ; `Score agreeShare(Iterable<int> ids, Answers a)` (part des notées ≥4) ; `({List<int> counts, int skipped}) counts(Iterable<int> ids, Answers a)` (counts de longueur 6) ; `Score similarity(Answers a, Answers b, int measureCount)` (100 − écart moyen des poids sur mesures notées par les deux).
- `({String ctx, String pro, String con})? splitInfo(String s)` — port fidèle de `splitInfo` du legacy (lignes ~129-149).
- `class Report { Score global; Score agree; List<int> counts; int skipped; Map<String,Score> byTheme; ... }` et `Report buildReport({required List<Measure> measures, required Iterable<int> ids, required Answers answers, required Comments comments})` ; `String reportAsText(...)` reproduisant `reportText()` du legacy.

- [ ] **Step 1: Write the failing tests.** `scoring_test` : réponses `{0:5,1:4,2:2,3:0}` sur ids 0..3 → `score.pct == 58` (moyenne (100+75+0)/3 arrondie), `n == 3` ; aucune réponse → `Score(pct:null,n:0)`; seulement `2` → `pct null`. `agreeShare` : `{0:5,1:4,2:3}` → 67. `counts` : non répondu = skipped, `2` compté dans `counts[2]`. `similarity_test` : mêmes réponses → 100 ; 5 vs 4 → 75 ; aucune commune → `pct null`. `info_splitter_test` : la chaîne de la mesure 0 (« …Pour ses partisans, elle répond à une pénurie ; pour ses critiques, … ») → `pro` commence par « Pour ses partisans, » et `con` par « Pour ses critiques, » ; chaîne sans partisans/critiques → `null`. `report_builder_test` : texte rapport contient « Accord global : 58 % sur 3 mesures notées ».
- [ ] **Step 2:** Run `flutter test test/domain` → FAIL.
- [ ] **Step 3:** Implémenter les fichiers selon les signatures. `splitInfo` : port des regex du legacy tel quel.
- [ ] **Step 4:** Run `flutter test test/domain` → PASS.
- [ ] **Step 5: Commit** — `feat(domain): entities and scoring services`.

### Task 4: Application — ports et cas d'usage

**Files:**
- Create: `lib/application/ports/{storage_port.dart,clipboard_port.dart,share_codec_port.dart,catalog_port.dart}`, `lib/application/state/app_state.dart`, `lib/application/usecases/{answer_measure.dart,navigate_quiz.dart,set_comment.dart,add_other.dart,remove_other.dart,reset_answers.dart,select_mode.dart,measure_ids_for.dart}`
- Test: `test/application/*_test.dart` + `test/application/fakes.dart`

**Interfaces:** Consumes: Task 3. Produces :
- `enum QuizMode { short, full }`, `enum ThemePref { auto, light, dark }`, `enum AppView { home, quiz, report, compare }`.
- `class AppState { ThemePref theme; bool openInfo; String name; QuizMode mode; AppView view; Answers answers; Comments comments; Map<QuizMode,int> pos; List<String> others /*codes*/; int cmpWith; copyWith(...) }`.
- Ports : `abstract class StoragePort { Future<AppState?> load(); Future<void> save(AppState s); }`, `abstract class ClipboardPort { Future<bool> copy(String text); }`, `abstract class ShareCodecPort { String encode(String name, Answers a, Comments c); Person decode(String code); /* lève ShareCodeException(message) */ }`, `abstract class CatalogPort { Future<Catalog> load(); }` avec `class Catalog { List<ThemeInfo> themes; List<Measure> measures; }`.
- Usecases (fonctions pures `AppState -> AppState`, le catalogue passé en argument) : `List<int> measureIdsFor(Catalog, QuizMode)` (phares si short ; tri par ordre de thème, `no`, `id`) ; `AppState answerMeasure(AppState, Catalog, int value)` (re-cliquer la même valeur l'efface) ; `AppState setComment(AppState, Catalog, String text)` (vide → supprime, tronque à 500) ; `AppState step(AppState, Catalog, int delta)` (dépasse la fin → `view = report`) ; `AppState addOther(AppState, ShareCodecPort, String rawCode)` (décode pour valider, normalise espaces, remplace si même prénom) ; `removeOther(AppState, int k)` ; `resetAnswers(AppState)`.

- [ ] **Step 1: Write the failing tests** (avec `FakeCodec`, mini-catalogue de 3 mesures) : `measureIdsFor(short)` ne renvoie que les phares ; `answerMeasure` deux fois la même valeur → clé supprimée ; `step(+1)` à la dernière mesure → `view == report` ; `setComment` avec 600 car. → longueur 500, avec `"  "` → supprimé ; `addOther` avec deux codes du même prénom → `others.length == 1` ; `addOther` code invalide → lève `ShareCodeException` et l'état est inchangé ; `resetAnswers` remet `pos` à 0 et `view = home`.
- [ ] **Step 2:** Run `flutter test test/application` → FAIL.
- [ ] **Step 3:** Implémenter ports, `AppState` (immuable), usecases.
- [ ] **Step 4:** Run → PASS ; `flutter analyze` propre.
- [ ] **Step 5: Commit** — `feat(application): ports and use cases`.

### Task 5: Infrastructure — adaptateurs

**Files:**
- Create: `lib/infrastructure/codec/base64_share_codec.dart`, `lib/infrastructure/storage/prefs_storage.dart`, `lib/infrastructure/clipboard/flutter_clipboard.dart`, `lib/infrastructure/catalog/asset_catalog.dart`
- Test: `test/infrastructure/{share_codec_test.dart,prefs_storage_test.dart}`

**Interfaces:** Consumes: ports de Task 4. Produces : `Base64ShareCodec implements ShareCodecPort` (constructeur `Base64ShareCodec({required int measureCount})`) ; `PrefsStorage(SharedPreferences) implements StoragePort` ; `FlutterClipboard implements ClipboardPort` ; `AssetCatalog implements CatalogPort` (lit `assets/measures.json` via `rootBundle`).

- [ ] **Step 1: Write the failing tests.** `share_codec_test` : (a) round-trip `encode('Léa',{0:5,3:0},{0:'ok'})` → `decode` redonne mêmes données ; (b) **code réel du legacy** : générer avec `node` (en rejouant `encodeCode` de `legacy/index.html` avec réponses `{0:5,1:2,5:0}`) et le coller en dur dans le test → décodé identique ; (c) code avec espaces/retours à la ligne au milieu → accepté ; (d) sans préfixe `BM1.` → `ShareCodeException('Ce code n’est pas reconnu. Il doit commencer par BM1.')` ; (e) base64 tronqué → `'Ce code est incomplet ou abîmé. Copie-le en entier.'` ; (f) `r` de 1035 caractères ou contenant `9` → même message « incomplet » ; (g) commentaire de 600 car. → tronqué à 500 ; (h) nom vide → « Sans nom », nom de 50 car. → 40. `prefs_storage_test` (avec `SharedPreferences.setMockInitialValues`) : save puis load redonne l'état ; JSON invalide `'{{'` → `load()` renvoie `null` sans lever.
- [ ] **Step 2:** Run `flutter test test/infrastructure` → FAIL.
- [ ] **Step 3:** Implémenter. Codec : `utf8` + `base64Url` sans padding, mêmes règles que `encodeCode/decodeCode` (legacy lignes ~57-92). Stockage : JSON `{theme,openInfo,name,mode,answers,comments,pos,others}` sous la clé `boussole-mesures-v1`, clés de `answers`/`comments` en chaînes comme le legacy.
- [ ] **Step 4:** Run → PASS.
- [ ] **Step 5: Commit** — `feat(infra): storage, BM1 codec, clipboard, asset catalog`.

### Task 6: État Riverpod et composition root

**Files:**
- Create: `lib/presentation/state/{providers.dart,app_controller.dart}`, `lib/main.dart`, `lib/app.dart`, `lib/presentation/router.dart`
- Test: `test/presentation/app_controller_test.dart`

**Interfaces:** Consumes: Tasks 4-5. Produces : providers `storageProvider`, `clipboardProvider`, `codecProvider`, `catalogProvider` (surchargés dans `main.dart`) ; `appControllerProvider` : `NotifierProvider<AppController, AppState>` avec méthodes `answer(int)`, `next()`, `prev()`, `setComment(String)`, `setName(String)`, `cycleTheme()`, `toggleOpenInfo()`, `start(QuizMode)`, `goTo(AppView)`, `switchMode(QuizMode)`, `addOther(String) -> String?` (message d'erreur ou null), `removeOther(int)`, `selectCompare(int)`, `reset()` ; chaque mutation appelle `storage.save`. Routes `go_router` : `/`, `/quiz`, `/report`, `/compare` synchronisées avec `AppView`.

- [ ] **Step 1: Write the failing test** (ProviderContainer avec faux ports) : `answer(5)` met à jour l'état et appelle `save` une fois ; `addOther('xx')` renvoie « Ce code n’est pas reconnu. Il doit commencer par BM1. » ; `cycleTheme` : auto→light→dark→auto.
- [ ] **Step 2:** Run → FAIL. **Step 3:** Implémenter ; `main.dart` charge l'état stocké (ou défaut) avant `runApp`. **Step 4:** Run → PASS. **Step 5: Commit** — `feat(presentation): riverpod controller and router`.

### Task 7: Design system, atoms, molecules

**Files:**
- Create: `lib/presentation/design_system/{tokens.dart,app_theme.dart}`, `lib/presentation/atoms/{app_button.dart,chip_button.dart,pill.dart,tag.dart,progress_bar.dart,text_field_box.dart,logo.dart,card_surface.dart}`, `lib/presentation/molecules/{answer_option.dart,bar_row.dart,theme_toggle.dart,info_table.dart,stat_figure.dart}`, `assets/fonts/*` (Bricolage Grotesque, Instrument Sans, licences OFL)
- Modify: `pubspec.yaml` (fonts)
- Test: `test/presentation/{atoms_test.dart,molecules_test.dart}`

**Interfaces:** Consumes: `scale`, `Score`, `splitInfo`. Produces : `AppTokens` (`ThemeExtension` clair/sombre avec les couleurs des Global Constraints, + `answerColor(int v)` : 0→s0, 1→s1, 2→muted, 3→s3, 4→s4, 5→s5) ; `buildTheme(Brightness)` ; widgets `Pill(int? value)` (« Passée » si null), `AnswerOption({label, keyHint, selected, onTap})`, `BarRow({label, Score score})` (affiche « — » si `pct == null`), `InfoTable(String info)` (2 colonnes partisans/critiques, ou un simple paragraphe si `splitInfo == null`).

- [ ] **Step 1: Write the failing widget tests :** `Pill(null)` affiche « Passée » ; `Pill(5)` affiche « D’accord » ; `BarRow` avec `Score(null,0)` affiche « — » ; `AnswerOption(selected:true)` expose `Semantics(selected: true)` ; `InfoTable` d'une info avec partisans/critiques affiche « Partisans de la mesure » et « Critiques de la mesure », sinon seulement le texte.
- [ ] **Step 2:** Run → FAIL. **Step 3:** Implémenter ; télécharger les polices (Google Fonts, licence OFL) dans `assets/fonts`. **Step 4:** Run → PASS. **Step 5: Commit** — `feat(ui): design system, atoms, molecules`.

### Task 8: Organismes, template et pages

**Files:**
- Create: `lib/presentation/organisms/{topbar.dart,footer_note.dart,measure_card.dart,answer_rail.dart,gauge.dart,stacked_distribution.dart,theme_bars.dart,top_list.dart,comments_list.dart,share_panel.dart,compare_intro.dart,compare_matrix.dart,compare_detail.dart}`, `lib/presentation/templates/page_layout.dart`, `lib/presentation/pages/{home_page.dart,quiz_page.dart,report_page.dart,compare_page.dart}`, `lib/presentation/keyboard_shortcuts.dart`
- Test: `test/presentation/{quiz_page_test.dart,report_page_test.dart,compare_page_test.dart,home_page_test.dart}`

**Interfaces:** Consumes: `appControllerProvider`, `Report`, molecules. Produces : `PageLayout({child})` (colonne centrée ≤760 px, `Topbar` avec Noter / Mon rapport / Comparer / thème) ; `Gauge(int pct)` en `CustomPainter` (arc 0–100 %) ; `QuizShortcuts({child})` : touches 1–5 → `answer(rail[k-1])`, 0 → `answer(2)`, flèches → `next/prev`, **ignorées si un `EditableText` a le focus** ; pages reproduisant `viewHome/viewQuiz/viewReport/viewCompare` du legacy avec leurs textes (accueil : reprise « mesures déjà notées », choix version courte 48 / complète 1034 ; rapport vide : « Ton rapport apparaîtra ici » ; comparaison sans proche : « Personne n’a encore été ajouté. »). Bouton « Effacer mes réponses » en deux temps (« Confirmer l’effacement de toutes mes réponses »).

- [ ] **Step 1: Write the failing widget tests** (ProviderScope avec faux ports et mini-catalogue) : quiz — appui touche `3` sélectionne « Neutre » (`answers[id]==3`) ; touche `1` avec focus dans le champ commentaire n'enregistre rien ; dernière mesure affiche « Voir mon rapport » ; rapport — sans notes affiche « Ton rapport apparaîtra ici » ; avec `{0:5}` affiche « 100 % » ; reset demande confirmation avant d'effacer ; comparaison — code invalide affiche l'erreur FR sous le champ ; deux codes → matrice « Tous les duos » absente (1 proche) / présente (≥2 proches) ; accueil — version courte annonce « 48 » et complète « 1034 ».
- [ ] **Step 2:** Run `flutter test test/presentation` → FAIL. **Step 3:** Implémenter ; layouts adaptatifs (tables → colonnes empilées sous 600 px). **Step 4:** Run → PASS ; `flutter analyze` propre. **Step 5: Commit** — `feat(ui): organisms, templates and pages`.

### Task 9: Docker/nginx web, README, Makefile

**Files:**
- Modify: `Dockerfile`, `docker-compose.yml`, `nginx.prod.conf`, `Makefile`, `README.md`, `.dockerignore`

**Interfaces:** Consumes: `flutter build web`. Produces : image prod `boussole-des-mesures` servie sur 8080 ; dev via `flutter run -d chrome` (cible `make dev`).

- [ ] **Step 1:** Dockerfile multi-stage : `ghcr.io/cirruslabs/flutter:3.44.7` → `flutter pub get && flutter build web --release` ; copie `build/web` dans `nginxinc/nginx-unprivileged:1.27-alpine` (conserver healthcheck et `/healthz`).
- [ ] **Step 2:** `nginx.prod.conf` : CSP `default-src 'self'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self'; worker-src 'self' blob:; base-uri 'none'; form-action 'none'; frame-ancestors 'none'` ; garder les autres en-têtes ; `wasm` en `application/wasm`.
- [ ] **Step 3:** Makefile : `dev`, `test` (`flutter test`), `web`, `macos`, `prod`, `stop`. README : prérequis, commandes par plateforme, note Windows/Linux (build sur la plateforme cible).
- [ ] **Step 4:** Vérifier : `docker compose --profile prod up -d --build` puis `curl -s localhost:8080/healthz` → `ok`, et `curl -sI localhost:8080/` → 200 avec l'en-tête CSP. (Si Docker est indisponible, le dire.)
- [ ] **Step 5: Commit** — `build: docker multi-stage for flutter web`.

### Task 10: Vérification finale

- [ ] **Step 1:** `flutter analyze` → « No issues found » ; `flutter test` → tous PASS.
- [ ] **Step 2:** `flutter build web --release` et `flutter build macos --release` → succès.
- [ ] **Step 3:** Lancer `flutter run -d chrome` (skill `run`), parcourir accueil → quiz (touches 1–5, 0, flèches) → rapport → copier le code → comparer ; comparer visuellement avec `legacy/index.html` ; signaler tout écart.
- [ ] **Step 4:** Si SDK dispo : `flutter build apk --debug` / `flutter build ios --no-codesign` ; sinon indiquer ce qui n'a pas été vérifié (Android : licences à accepter, Windows/Linux : non buildables sur Mac).
- [ ] **Step 5: Commit** — `chore: final verification`.

---

## Self-review

- **Couverture du spec :** 6 plateformes (T1, T10), JSON (T2), domaine (T3), application (T4), infra (T5), Riverpod/go_router (T6), design system/polices (T7), pages/clavier/colonne 760 (T8), Docker/CSP/README/Makefile (T9), vérification (T10), `legacy/` (T1).
- **Cohérence des types :** `Answers`, `Comments`, `Score`, `Catalog`, `AppState`, `QuizMode` définis en T3-T4 et réutilisés tels quels.
- **Écart assumé vs spec :** les tâches 1–10 regroupent les 9 du spec (le state Riverpod devient la T6 pour isoler sa testabilité).
