import '../models/course_models.dart';

/// Opțiunile de sortare pentru lista de cursuri.
enum CourseSort { title, progress, lessons }

extension CourseSortLabel on CourseSort {
  String get label => switch (this) {
        CourseSort.title => 'Titlu (A-Z)',
        CourseSort.progress => 'Progres (mare → mic)',
        CourseSort.lessons => 'Lecții (multe → puține)',
      };
}

class CourseFilter {
  final String id;
  final String label;

  const CourseFilter(this.id, this.label);
}

const kCourseFilters = <CourseFilter>[
  CourseFilter('all', 'Toate'),
  CourseFilter('design', 'Design'),
  CourseFilter('development', 'Development'),
  CourseFilter('inProgress', 'În progres'),
  CourseFilter('completed', 'Finalizate'),
];

/// Stările aplicației. `sealed` => switch exhaustiv în UI.
sealed class CoursesState {
  const CoursesState();
}

/// Se încarcă JSON-ul.
class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

/// Datele nu au putut fi încărcate.
class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);
}

/// Date încărcate; subclasele arată dacă lista filtrată are elemente.
sealed class CoursesLoaded extends CoursesState {
  final AppData data;
  final List<CourseSummary> visibleCourses;
  final String query;
  final String filterId;
  final CourseSort sort;
  final Set<String> favoriteIds;

  const CoursesLoaded({
    required this.data,
    required this.visibleCourses,
    required this.query,
    required this.filterId,
    required this.sort,
    required this.favoriteIds,
  });
}

/// Există cel puțin un curs după căutare + filtrare.
class CoursesSuccess extends CoursesLoaded {
  const CoursesSuccess({
    required super.data,
    required super.visibleCourses,
    required super.query,
    required super.filterId,
    required super.sort,
    required super.favoriteIds,
  });
}

/// Lista este goală după căutare + filtrare.
class CoursesEmpty extends CoursesLoaded {
  const CoursesEmpty({
    required super.data,
    required super.visibleCourses,
    required super.query,
    required super.filterId,
    required super.sort,
    required super.favoriteIds,
  });
}
