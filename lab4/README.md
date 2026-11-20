# Learning App — Laboratorul 4 (Varianta 4, Lucian)

Aplicație Flutter care păstrează **designul din Laboratorul 3** (learning app
cu paletă portocalie, dashboard, filtre, Course Overview și Lesson Detail), dar
preia toate datele dintr-un **serviciu Web REST** folosind serializare JSON și
**Clean Architecture**. Nu există date locale în `assets` pentru cursuri.

## Funcționalități

- ecran principal cu antet (salut, avatar, notificare) și card „Learned today”
- listă de cursuri construită din feed + detalii, cu progres real din API
- căutare, filtre (Toate / Design / Development / În progres / Finalizate) și
  sortare (Titlu / Progres / Lecții) — păstrate din Laboratorul 3
- favorite pentru cursuri (în `HomeCubit`) și pentru lecții (în `OverviewCubit`)
- pull-to-refresh pe ecranul principal
- ecran „Course Overview” cu hero, durată, număr de lecții, rating și tab-uri
  Lessons / Description
- căutare, filtre și sortare pentru lecții; lecții finalizate și blocate
- ecran „Lesson Detail” cu iconița de redare livrată de API
- stări explicite de încărcare, eroare (cu reîncercare) și conținut lipsă
- iconițe SVG de la Iconify, afișate prin `flutter_svg`

## Arhitectură

Straturile sunt direct sub `lib/` — se văd imediat când deschizi folderul:

```
lib/
├── main.dart                   → composition root (aici se leagă straturile)
├── app.dart                    → MaterialApp + BlocProviders
│
├── domain/   ← README.md       → STRATUL DE BUSINESS (nu depinde de nimic)
│   ├── entities/               → obiecte pure, fără JSON / Flutter
│   ├── repositories/           → contractul abstract LearningRepository
│   └── usecases/               → GetLearningFeed, GetCourseDetails
│
├── data/     ← README.md       → STRATUL DE DATE (depinde doar de domain)
│   ├── models/                 → fromJson / toJson (serializare)
│   ├── datasources/            → singurul loc cu cereri HTTP
│   └── repositories/           → LearningRepositoryImpl (eroare → Failure)
│
├── presentation/ ← README.md   → STRATUL UI (depinde doar de domain)
│   ├── cubit/                  → HomeCubit, OverviewCubit + stările lor
│   ├── models/                 → CourseListItem, Filters (modele UI)
│   ├── pages/                  → HomePage, CourseOverviewPage, LessonDetailPage
│   └── widgets/                → componente reutilizabile
│
└── core/     ← README.md       → infrastructură partajată
    ├── network/                → ApiClient (HTTP)
    ├── error/                  → Failure
    ├── constants/              → URL-urile API-ului
    ├── theme/                  → tema portocalie (din Lab 3)
    └── widgets/                → widget-uri comune
```

> Regula dependențelor: `presentation → domain ← data`.
> `domain` nu importă niciodată `data` sau `presentation` — verifici cu un singur
> `grep`: `grep -rn "data/\|presentation/" lib/domain` (nu returnează nimic).

### Ghid de demonstrație (în această ordine)

Deschide fișierele în editor, unul câte unul, și arată fluxul complet:

1. `lib/main.dart` — aici se construiesc obiectele și se injectează dependențele
2. `lib/domain/entities/learning_feed.dart` — entitate pură, fără JSON
3. `lib/domain/repositories/learning_repository.dart` — doar contractul (`abstract`)
4. `lib/domain/usecases/get_learning_feed.dart` — o acțiune = o clasă
5. `lib/data/models/learning_feed_model.dart` — `fromJson` (serializare)
6. `lib/data/datasources/learning_remote_data_source.dart` — cererea HTTP reală
7. `lib/data/repositories/learning_repository_impl.dart` — model → entitate, eroare → `Failure`
8. `lib/presentation/cubit/home_cubit.dart` — pornește ambele cereri în paralel, emite stare
9. `lib/presentation/pages/home_page.dart` — `LoadingView` / `ErrorView` / conținut + filtre

Arată apoi `lib/domain/README.md`, `lib/data/README.md` și
`lib/presentation/README.md` — fiecare strat are propriul README cu regula lui.

### Fluxul UI → API → UI

```
HomePage / CourseOverviewPage / LessonDetailPage
  → HomeCubit / OverviewCubit
    → GetLearningFeed / GetCourseDetails (domain)
      → LearningRepository (abstract)
        → LearningRepositoryImpl (data)
          → LearningRemoteDataSource
            → ApiClient (HTTP + decode JSON)
              → serviciul Web REST (HTTPS)
```

`ApiClient` transformă erorile tehnice (socket, timeout, JSON invalid, cod HTTP)
în obiecte `Failure`. Modelele (`LearningFeedModel`, `CourseDetailsModel`)
deserializează JSON-ul în entități, iar cubit-urile emit stăți care declară
interfața ce să afișeze: `LoadingView`, `ErrorView`, `EmptyView` sau conținutul.

Cele două cereri API din `HomeCubit.load()` pornesc în paralel (record `.wait`),
iar `ParallelWaitError` este tratat pentru a afișa un mesaj de eroare clar când
ambele cereri eșuează (ex. lipsă rețea).

## Serviciul Web

- `GET /lab2026/v4/feed` — feed-ul de learning
- `GET /lab2026/v4/feed/details` — detaliile cursului (Course Overview)

Host: `test-api-jlbn.onrender.com` (HTTPS).

## Rulare

```bash
flutter pub get
flutter run
```

## Testare

```bash
flutter analyze
flutter test
```

Cele 32 de teste acoperă: deserializarea/serializarea modelelor JSON, logica din
`HomeCubit` (încărcare paralelă, filtre, sortare, favorite, erori) și
`OverviewCubit` (tab-uri, filtrare lecții, sortare, favorite), widget-urile
reutilizabile (`LessonTile`) și ecranele `HomePage` / `CourseOverviewPage`.
