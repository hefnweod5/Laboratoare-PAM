import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/course_models.dart';
import 'overview_state.dart';

/// Cubit pentru ecranul de detalii: tab-uri, căutare, filtrare, sortare și
/// favorite pentru lista de lecții.
class CourseOverviewCubit extends Cubit<OverviewState> {
  CourseOverviewCubit(Course course)
      : super(OverviewState(
          course: course,
          tabId: course.tabs.selected,
          query: '',
          filter: LessonFilter.all,
          sort: LessonSort.order,
          favoriteLessonIds: const {},
        ));

  void setTab(String tabId) => emit(state.copyWith(tabId: tabId));

  void setQuery(String value) => emit(state.copyWith(query: value));

  void setFilter(LessonFilter filter) => emit(state.copyWith(filter: filter));

  void setSort(LessonSort sort) => emit(state.copyWith(sort: sort));

  void toggleFavorite(String lessonId) {
    final favorites = Set<String>.of(state.favoriteLessonIds);
    if (!favorites.remove(lessonId)) {
      favorites.add(lessonId);
    }
    emit(state.copyWith(favoriteLessonIds: favorites));
  }

  void resetFilters() => emit(state.copyWith(
        query: '',
        filter: LessonFilter.all,
        sort: LessonSort.order,
      ));
}
