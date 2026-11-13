# Readly — Feed de articole

Aplicație Flutter care consumă un serviciu Web REST (DummyJSON) și este
organizată după principiile Clean Architecture.

## Funcționalități

- feed de articole încărcat de la `GET /posts`
- paginare automată la scroll
- căutare cu debounce prin `GET /posts/search`
- sortare efectuată pe server (cele mai noi, cele mai citite, titlu A-Z / Z-A)
- ecran de lectură cu conținutul complet preluat din `GET /posts/{id}`
- timp estimat de lectură calculat din numărul de cuvinte
- listă de articole salvate
- stări explicite de încărcare, eroare și listă goală
- pull-to-refresh

## Arhitectură

```
lib/
├── core/                     rețea, erori, temă, widget-uri comune
└── features/feed/
    ├── domain/               entități, contract repository, use cases
    ├── data/                 modele JSON, data source, repository impl
    └── presentation/         cubit-uri, ecrane, widget-uri reutilizabile
```

### Fluxul datelor

```
UI (FeedPage)
  → FeedCubit
    → GetArticles / SearchArticles (domain)
      → ArticleRepository (abstract)
        → ArticleRepositoryImpl (data)
          → ArticleRemoteDataSource
            → ApiClient (HTTP)
              → DummyJSON
```

Răspunsul JSON este deserializat în `ArticleModel`, convertit în entitatea
`Article` și trimis înapoi prin cubit către interfață. Erorile tehnice sunt
transformate în `Failure` înainte de a ajunge în stratul de prezentare, iar
ecranul de detalii folosește un cubit separat și aceeași conductă de date.

## Serviciul Web

- `GET /posts?limit=&skip=&sortBy=&order=`
- `GET /posts/search?q=&limit=`
- `GET /posts/{id}`

## Rulare

```bash
flutter pub get
flutter run
```

## Testare

```bash
flutter test
```

Testele acoperă deserializarea/serializarea JSON, logica din `FeedCubit` și
componenta reutilizabilă `ArticleCard`.
