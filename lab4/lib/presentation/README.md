# PRESENTATION — stratul de interfață (UI)

**Regula de aur:** depinde de `domain/` (apelează use case-urile).
Nu importă `data/` — nu știe cum se face cererea HTTP sau cum arată JSON-ul.

| Subfolder | Ce conține | De ce e aici |
|---|---|---|
| `cubit/` | `HomeCubit`, `OverviewCubit` + stările lor | țin starea și traduc evenimentele UI în apeluri de use case |
| `pages/` | `HomePage`, `CourseOverviewPage`, `LessonDetailPage` | ecranele aplicației |
| `widgets/` | `HomeHeader`, `CourseCard`, `LessonTile`, … | componente reutilizabile, independente de ecran |
| `models/` | `CourseListItem`, `Filters` | modele UI (ce afișează ecranul, nu ce vine din API) |

**Fluxul:** `UI → Cubit → UseCase → Repository → API → ... → Cubit → UI`

Cubit-ul emite stări explicite, iar pagina afișează:
`LoadingView` (încărcare), `ErrorView` (eroare + reîncercare),
`EmptyView` (conținut lipsă) sau conținutul propriu-zis.
