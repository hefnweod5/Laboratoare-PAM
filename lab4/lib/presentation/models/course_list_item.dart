import '../../domain/entities/course_details.dart';
import '../../domain/entities/learning_feed.dart';

/// Model de prezentare: unește cursul detaliat și elementele din plan.
///
/// În Laboratorul 3 lista era construită din `courses.json`; acum aceeași
/// listă este construită din cele două răspunsuri primite prin REST API.
class CourseListItem {
  const CourseListItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryLabel,
    required this.progress,
    required this.completed,
    required this.total,
    this.durationMinutes,
    this.lessonCount,
    this.rating,
    this.heroImageUrl,
    this.progressIconUrl,
    this.isLearningPlan = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String categoryLabel;
  final double progress;
  final int completed;
  final int total;
  final int? durationMinutes;
  final int? lessonCount;
  final double? rating;
  final String? heroImageUrl;
  final String? progressIconUrl;
  final bool isLearningPlan;

  bool get isCompleted => total > 0 && completed >= total;
}

/// Construiește lista de cursuri afișată în home, fără date hardcodate.
List<CourseListItem> buildCourseItems(LearningFeed feed, CourseDetails details) {
  final course = details.course;
  final items = <CourseListItem>[
    CourseListItem(
      id: course.id,
      title: course.title,
      subtitle: '${course.lessonCount} lessons • ${course.duration}',
      categoryLabel: 'Development',
      progress: 0,
      completed: 0,
      total: course.lessonCount,
      durationMinutes: course.durationMinutes,
      lessonCount: course.lessonCount,
      rating: course.rating,
      heroImageUrl: course.hero.imageUrl,
    ),
  ];

  for (final item in feed.learningPlan.items) {
    items.add(
      CourseListItem(
        id: item.id,
        title: item.title,
        subtitle: feed.learningPlan.title,
        categoryLabel: item.title.toLowerCase().contains('design')
            ? 'Design'
            : 'Development',
        progress: item.progress,
        completed: item.completed,
        total: item.total,
        progressIconUrl: item.progressIconUrl,
        isLearningPlan: true,
      ),
    );
  }

  return items;
}
