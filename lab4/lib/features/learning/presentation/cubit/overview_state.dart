import 'package:equatable/equatable.dart';

import '../../domain/entities/course_details.dart';
import '../models/filters.dart';

/// Starea UI a ecranului de detalii (datele vin din API prin HomeCubit).
class OverviewState extends Equatable {
  const OverviewState({
    required this.details,
    this.tabId = 'lessons',
    this.query = '',
    this.filter = LessonFilter.all,
    this.sort = LessonSort.order,
    this.favoriteLessonIds = const <String>{},
  });

  final CourseDetails details;
  final String tabId;
  final String query;
  final LessonFilter filter;
  final LessonSort sort;
  final Set<String> favoriteLessonIds;

  List<Lesson> get visibleLessons {
    var lessons = List<Lesson>.from(details.course.lessons);

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      lessons =
          lessons.where((lesson) => lesson.title.toLowerCase().contains(q)).toList();
    }

    lessons = switch (filter) {
      LessonFilter.completed =>
        lessons.where((lesson) => lesson.completed).toList(),
      LessonFilter.locked => lessons.where((lesson) => lesson.locked).toList(),
      LessonFilter.all => lessons,
    };

    switch (sort) {
      case LessonSort.order:
        break;
      case LessonSort.title:
        lessons.sort((a, b) => a.title.compareTo(b.title));
      case LessonSort.duration:
        lessons.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    }

    return lessons;
  }

  OverviewState copyWith({
    CourseDetails? details,
    String? tabId,
    String? query,
    LessonFilter? filter,
    LessonSort? sort,
    Set<String>? favoriteLessonIds,
  }) {
    return OverviewState(
      details: details ?? this.details,
      tabId: tabId ?? this.tabId,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      favoriteLessonIds: favoriteLessonIds ?? this.favoriteLessonIds,
    );
  }

  @override
  List<Object?> get props => [
        details,
        tabId,
        query,
        filter,
        sort,
        favoriteLessonIds,
      ];
}
