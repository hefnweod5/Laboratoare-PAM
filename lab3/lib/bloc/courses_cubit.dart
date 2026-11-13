import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/course_repository.dart';
import '../models/course_models.dart';
import 'courses_state.dart';

/// Cubit-ul principal: încarcă datele asincron și gestionează lista de cursuri
/// (căutare, filtrare, sortare, favorite).
class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this._repository) : super(const CoursesLoading());

  final CourseRepository _repository;

  AppData? _data;
  List<CourseSummary> _courses = const [];
  String _query = '';
  String _filterId = 'all';
  CourseSort _sort = CourseSort.title;
  final Set<String> _favorites = <String>{};

  /// Loading -> Success / Empty sau Error.
  Future<void> load() async {
    emit(const CoursesLoading());
    try {
      final data = await _repository.load();
      _data = data;
      _courses = buildCourseSummaries(data);
      _emitView();
    } catch (e) {
      emit(CoursesError('Nu am putut încărca datele. ($e)'));
    }
  }

  void setQuery(String value) {
    _query = value;
    _emitView();
  }

  void setFilter(String id) {
    _filterId = id;
    _emitView();
  }

  void setSort(CourseSort sort) {
    _sort = sort;
    _emitView();
  }

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) {
      _favorites.add(id);
    }
    _emitView();
  }

  void resetFilters() {
    _query = '';
    _filterId = 'all';
    _sort = CourseSort.title;
    _emitView();
  }

  void _emitView() {
    final data = _data;
    if (data == null) return;

    final visible = _applyFilters(_courses);
    final favorites = Set<String>.of(_favorites);

    if (visible.isEmpty) {
      emit(CoursesEmpty(
        data: data,
        visibleCourses: visible,
        query: _query,
        filterId: _filterId,
        sort: _sort,
        favoriteIds: favorites,
      ));
    } else {
      emit(CoursesSuccess(
        data: data,
        visibleCourses: visible,
        query: _query,
        filterId: _filterId,
        sort: _sort,
        favoriteIds: favorites,
      ));
    }
  }

  List<CourseSummary> _applyFilters(List<CourseSummary> courses) {
    final q = _query.trim().toLowerCase();

    final result = courses.where((course) {
      final byQuery = q.isEmpty || course.title.toLowerCase().contains(q);
      final byFilter = switch (_filterId) {
        'design' => course.category == CourseCategory.design,
        'development' => course.category == CourseCategory.development,
        'inProgress' => !course.isCompleted,
        'completed' => course.isCompleted,
        _ => true,
      };
      return byQuery && byFilter;
    }).toList();

    switch (_sort) {
      case CourseSort.title:
        result.sort((a, b) => a.title.compareTo(b.title));
      case CourseSort.progress:
        result.sort((a, b) => b.progress.compareTo(a.progress));
      case CourseSort.lessons:
        result.sort((a, b) => b.total.compareTo(a.total));
    }
    return result;
  }
}
