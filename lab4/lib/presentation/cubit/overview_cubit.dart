import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course_details.dart';
import '../models/filters.dart';
import 'overview_state.dart';

/// Gestionează tab-urile, căutarea, filtrele și favoritele din Course Overview.
class OverviewCubit extends Cubit<OverviewState> {
  OverviewCubit(CourseDetails details)
      : super(
          OverviewState(
            details: details,
            tabId: details.course.tabs.selected,
          ),
        );

  void setTab(String id) => emit(state.copyWith(tabId: id));

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setFilter(LessonFilter filter) => emit(state.copyWith(filter: filter));

  void setSort(LessonSort sort) => emit(state.copyWith(sort: sort));

  void toggleFavorite(String id) {
    final favorites = Set<String>.from(state.favoriteLessonIds);
    if (!favorites.remove(id)) favorites.add(id);
    emit(state.copyWith(favoriteLessonIds: favorites));
  }

  void resetFilters() => emit(
        state.copyWith(
          query: '',
          filter: LessonFilter.all,
          sort: LessonSort.order,
        ),
      );
}
