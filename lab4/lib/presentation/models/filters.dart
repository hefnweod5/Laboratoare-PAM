// Opțiuni de filtrare și sortare, păstrate din Laboratorul 3.

enum CourseFilter { all, design, development, inProgress, completed }

extension CourseFilterLabel on CourseFilter {
  String get label => switch (this) {
        CourseFilter.all => 'Toate',
        CourseFilter.design => 'Design',
        CourseFilter.development => 'Development',
        CourseFilter.inProgress => 'În progres',
        CourseFilter.completed => 'Finalizate',
      };
}

enum CourseSort { title, progress, lessons }

extension CourseSortLabel on CourseSort {
  String get label => switch (this) {
        CourseSort.title => 'Titlu',
        CourseSort.progress => 'Progres',
        CourseSort.lessons => 'Lecții',
      };
}

enum LessonFilter { all, completed, locked }

extension LessonFilterLabel on LessonFilter {
  String get label => switch (this) {
        LessonFilter.all => 'Toate',
        LessonFilter.completed => 'Finalizate',
        LessonFilter.locked => 'Blocate',
      };
}

enum LessonSort { order, title, duration }

extension LessonSortLabel on LessonSort {
  String get label => switch (this) {
        LessonSort.order => 'Ordine',
        LessonSort.title => 'Titlu',
        LessonSort.duration => 'Durată',
      };
}
