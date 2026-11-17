import 'package:equatable/equatable.dart';

import '../../domain/entities/course_details.dart';
import '../../domain/entities/learning_feed.dart';
import '../models/course_list_item.dart';
import '../models/filters.dart';

enum HomeStatus { initial, loading, success, failure }

/// Starea ecranului principal: datele din API + filtrele din Laboratorul 3.
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.feed,
    this.details,
    this.errorMessage,
    this.query = '',
    this.filterId = 'all',
    this.sort = CourseSort.title,
    this.favoriteIds = const <String>{},
  });

  final HomeStatus status;
  final LearningFeed? feed;
  final CourseDetails? details;
  final String? errorMessage;
  final String query;
  final String filterId;
  final CourseSort sort;
  final Set<String> favoriteIds;

  List<CourseListItem> get visibleCourses {
    final feed = this.feed;
    final details = this.details;
    if (feed == null || details == null) return const [];

    var items = buildCourseItems(feed, details);

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      items = items.where((item) => item.title.toLowerCase().contains(q)).toList();
    }

    items = switch (filterId) {
      'design' => items
          .where((item) => item.categoryLabel.toLowerCase() == 'design')
          .toList(),
      'development' => items
          .where((item) => item.categoryLabel.toLowerCase() == 'development')
          .toList(),
      'inProgress' => items
          .where((item) => item.progress > 0 && item.progress < 1)
          .toList(),
      'completed' => items.where((item) => item.isCompleted).toList(),
      _ => items,
    };

    switch (sort) {
      case CourseSort.title:
        items.sort((a, b) => a.title.compareTo(b.title));
      case CourseSort.progress:
        items.sort((a, b) => b.progress.compareTo(a.progress));
      case CourseSort.lessons:
        items.sort((a, b) => (b.lessonCount ?? b.total).compareTo(a.lessonCount ?? a.total));
    }

    return items;
  }

  HomeState copyWith({
    HomeStatus? status,
    LearningFeed? feed,
    CourseDetails? details,
    String? errorMessage,
    String? query,
    String? filterId,
    CourseSort? sort,
    Set<String>? favoriteIds,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      details: details ?? this.details,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      query: query ?? this.query,
      filterId: filterId ?? this.filterId,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        feed,
        details,
        errorMessage,
        query,
        filterId,
        sort,
        favoriteIds,
      ];
}
