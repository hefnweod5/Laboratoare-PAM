# Course Learning App

A data-driven Flutter application that loads its content from a bundled JSON
file and manages state with `flutter_bloc`.

## Features

- asynchronous loading from `assets/data/courses.json`
- explicit `Loading`, `Success`, `Empty` and `Error` states
- search, filtering, sorting and favourites
- home dashboard, course overview and lesson details

## Structure

```
lib/
├── bloc/      state management (Cubit)
├── data/      repository and JSON loading
├── models/    data models
├── screens/   application screens
└── widgets/   reusable UI components
```

## Run

```bash
flutter pub get
flutter run
```
