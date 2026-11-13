import '../models/course_models.dart';

/// Filtrele pentru lista de lecții din ecranul de detalii.
enum LessonFilter { all, completed, locked }

extension LessonFilterLabel on LessonFilter {
  String get label => switch (this) {
        LessonFilter.all => 'Toate',
        LessonFilter.completed => 'Finalizate',
        LessonFilter.locked => 'Blocate',
      };
}

/// Sortarea lecțiilor.
enum LessonSort { order, title, duration }

extension LessonSortLabel on LessonSort {
  String get label => switch (this) {
        LessonSort.order => 'Ordine din JSON',
        LessonSort.title => 'Titlu (A-Z)',
        LessonSort.duration => 'Durată (scurt → lung)',
      };
}

class OverviewState {
  final Course course;
  final String tabId;
  final String query;
  final LessonFilter filter;
  final LessonSort sort;
  final Set<String> favoriteLessonIds;

  const OverviewState({
    required this.course,
    required this.tabId,
    required this.query,
    required this.filter,
    required this.sort,
    required this.favoriteLessonIds,
  });

  List<Lesson> get visibleLessons {
    final q = query.trim().toLowerCase();
    final list = course.lessons.where((lesson) {
      final byQuery = q.isEmpty || lesson.title.toLowerCase().contains(q);
      final byFilter = switch (filter) {
        LessonFilter.all => true,
        LessonFilter.completed => lesson.completed,
        LessonFilter.locked => lesson.locked,
      };
      return byQuery && byFilter;
    }).toList();

    switch (sort) {
      case LessonSort.order:
        break;
      case LessonSort.title:
        list.sort((a, b) => a.title.compareTo(b.title));
      case LessonSort.duration:
        list.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    }
    return list;
  }

  bool get isEmpty => visibleLessons.isEmpty;

  OverviewState copyWith({
    String? tabId,
    String? query,
    LessonFilter? filter,
    LessonSort? sort,
    Set<String>? favoriteLessonIds,
  }) {
    return OverviewState(
      course: course,
      tabId: tabId ?? this.tabId,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      favoriteLessonIds: favoriteLessonIds ?? this.favoriteLessonIds,
    );
  }
}
