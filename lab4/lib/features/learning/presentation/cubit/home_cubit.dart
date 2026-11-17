import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_course_details.dart';
import '../../domain/usecases/get_learning_feed.dart';
import '../models/filters.dart';
import 'home_state.dart';

/// Încarcă ambele răspunsuri API și gestionează filtrele din home.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.getLearningFeed,
    required this.getCourseDetails,
  }) : super(const HomeState());

  final GetLearningFeed getLearningFeed;
  final GetCourseDetails getCourseDetails;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    try {
      // Ambele viitoare pornesc înainte de primul `await`: cererile sunt paralele.
      // Recordul `.wait` atașează handleri de eroare ambelor viitoare, deci
      // nicio eroare nu rămâne negestionată dacă una dintre ele eșuează prima.
      final (feed, details) = await (
        getLearningFeed(),
        getCourseDetails(),
      ).wait;
      if (isClosed) return;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          feed: feed,
          details: details,
          clearError: true,
        ),
      );
    } on ParallelWaitError catch (parallel) {
      // Ambele cereri au eșuat (ex. lipsă rețea). Recordul `errors` păstrează
      // câte un AsyncError pentru fiecare viitoare care a aruncat.
      if (isClosed) return;
      final errors = parallel.errors as (AsyncError?, AsyncError?);
      final firstError = errors.$1 ?? errors.$2;
      final failure = firstError?.error;
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure is Failure
              ? failure.message
              : 'Datele nu au putut fi încărcate.',
        ),
      );
    } on Failure catch (failure) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> refresh() => load();

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setFilter(String id) => emit(state.copyWith(filterId: id));

  void setSort(CourseSort sort) => emit(state.copyWith(sort: sort));

  void toggleFavorite(String id) {
    final favorites = Set<String>.from(state.favoriteIds);
    if (!favorites.remove(id)) favorites.add(id);
    emit(state.copyWith(favoriteIds: favorites));
  }

  void resetFilters() => emit(
        state.copyWith(
          query: '',
          filterId: 'all',
          sort: CourseSort.title,
        ),
      );
}
