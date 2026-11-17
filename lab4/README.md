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

```
lib/
├── core/                       rețea (ApiClient), erori (Failure), temă, widget-uri
└── features/learning/
    ├── domain/                 entități, contract LearningRepository, use cases
    ├── data/                   modele JSON, data source REST, repository impl
    └── presentation/           HomeCubit / OverviewCubit, pagini, widget-uri
```

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
