// Modelele de date, construite 1:1 din courses.json (lab v4.json).
//
// Fiecare clasa de aici corespunde unei secțiuni din fișierul JSON:
//   homePage            -> HomePage
//   courseOverviewPage  -> CourseOverview

Map<String, dynamic> _map(dynamic value) =>
    (value as Map).cast<String, dynamic>();

List<T> _list<T>(dynamic value, T Function(Map<String, dynamic>) build) =>
    (value as List? ?? const [])
        .map((e) => build(_map(e)))
        .toList(growable: false);

int _int(dynamic value) => (value as num).toInt();
double _double(dynamic value) => (value as num).toDouble();
String _str(dynamic value) => value as String;

// ---------------------------------------------------------------------------
// Rădăcina
// ---------------------------------------------------------------------------

class AppData {
  final HomePage home;
  final CourseOverview overview;

  const AppData({required this.home, required this.overview});

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        home: HomePage.fromJson(_map(json['homePage'])),
        overview: CourseOverview.fromJson(_map(json['courseOverviewPage'])),
      );
}

// ---------------------------------------------------------------------------
// homePage
// ---------------------------------------------------------------------------

class HomePage {
  final HomeHeader header;
  final LearnedToday learnedToday;
  final SectionLabel myCourses;
  final LearningPrompt learningPrompt;
  final LearningPlan learningPlan;
  final Meetup meetup;

  const HomePage({
    required this.header,
    required this.learnedToday,
    required this.myCourses,
    required this.learningPrompt,
    required this.learningPlan,
    required this.meetup,
  });

  factory HomePage.fromJson(Map<String, dynamic> j) => HomePage(
        header: HomeHeader.fromJson(_map(j['header'])),
        learnedToday: LearnedToday.fromJson(_map(j['learnedToday'])),
        myCourses: SectionLabel.fromJson(_map(j['myCourses'])),
        learningPrompt: LearningPrompt.fromJson(_map(j['learningPrompt'])),
        learningPlan: LearningPlan.fromJson(_map(j['learningPlan'])),
        meetup: Meetup.fromJson(_map(j['meetup'])),
      );
}

class HomeHeader {
  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnread;
  final String notificationIconUrl;

  const HomeHeader({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnread,
    required this.notificationIconUrl,
  });

  factory HomeHeader.fromJson(Map<String, dynamic> j) {
    final notification = _map(j['notification']);
    return HomeHeader(
      greeting: _str(j['greeting']),
      subtitle: _str(j['subtitle']),
      avatarUrl: _str(j['avatarUrl']),
      hasUnread: notification['hasUnread'] as bool,
      notificationIconUrl: _str(notification['iconUrl']),
    );
  }
}

class LearnedToday {
  final String title;
  final int learnedMinutes;
  final int goalMinutes;
  final String formatted;
  final double progress;

  const LearnedToday({
    required this.title,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.formatted,
    required this.progress,
  });

  factory LearnedToday.fromJson(Map<String, dynamic> j) => LearnedToday(
        title: _str(j['title']),
        learnedMinutes: _int(j['learnedMinutes']),
        goalMinutes: _int(j['goalMinutes']),
        formatted: _str(j['formatted']),
        progress: _double(j['progress']),
      );
}

class SectionLabel {
  final String title;
  final String actionLabel;

  const SectionLabel({required this.title, required this.actionLabel});

  factory SectionLabel.fromJson(Map<String, dynamic> j) => SectionLabel(
        title: _str(j['title']),
        actionLabel: _str(j['actionLabel']),
      );
}

class LearningPrompt {
  final String title;
  final String actionLabel;
  final String imageUrl;

  const LearningPrompt({
    required this.title,
    required this.actionLabel,
    required this.imageUrl,
  });

  factory LearningPrompt.fromJson(Map<String, dynamic> j) => LearningPrompt(
        title: _str(j['title']),
        actionLabel: _str(j['actionLabel']),
        imageUrl: _str(j['imageUrl']),
      );
}

class LearningPlan {
  final String title;
  final List<PlanItem> items;

  const LearningPlan({required this.title, required this.items});

  factory LearningPlan.fromJson(Map<String, dynamic> j) => LearningPlan(
        title: _str(j['title']),
        items: _list(j['items'], PlanItem.fromJson),
      );
}

class PlanItem {
  final String id;
  final String title;
  final int completed;
  final int total;
  final double progress;
  final String progressIconUrl;

  const PlanItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.progress,
    required this.progressIconUrl,
  });

  factory PlanItem.fromJson(Map<String, dynamic> j) => PlanItem(
        id: _str(j['id']),
        title: _str(j['title']),
        completed: _int(j['completed']),
        total: _int(j['total']),
        progress: _double(j['progress']),
        progressIconUrl: _str(j['progressIconUrl']),
      );
}

class Meetup {
  final String title;
  final String subtitle;
  final String imageUrl;

  const Meetup({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory Meetup.fromJson(Map<String, dynamic> j) => Meetup(
        title: _str(j['title']),
        subtitle: _str(j['subtitle']),
        imageUrl: _str(j['imageUrl']),
      );
}

// ---------------------------------------------------------------------------
// courseOverviewPage
// ---------------------------------------------------------------------------

class CourseOverview {
  final NavigationInfo navigation;
  final Course course;
  final CourseActions actions;
  final UiIcons uiIcons;

  const CourseOverview({
    required this.navigation,
    required this.course,
    required this.actions,
    required this.uiIcons,
  });

  factory CourseOverview.fromJson(Map<String, dynamic> j) => CourseOverview(
        navigation: NavigationInfo.fromJson(_map(j['navigation'])),
        course: Course.fromJson(_map(j['course'])),
        actions: CourseActions.fromJson(_map(j['actions'])),
        uiIcons: UiIcons.fromJson(_map(j['uiIcons'])),
      );
}

class NavigationInfo {
  final String title;
  final String backIconUrl;

  const NavigationInfo({required this.title, required this.backIconUrl});

  factory NavigationInfo.fromJson(Map<String, dynamic> j) => NavigationInfo(
        title: _str(j['title']),
        backIconUrl: _str(j['backIconUrl']),
      );
}

class Course {
  final String id;
  final String title;
  final String duration;
  final int durationMinutes;
  final int lessonCount;
  final double rating;
  final CourseHero hero;
  final CourseTabs tabs;
  final List<Lesson> lessons;
  final CourseDescription description;

  const Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationMinutes,
    required this.lessonCount,
    required this.rating,
    required this.hero,
    required this.tabs,
    required this.lessons,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> j) => Course(
        id: _str(j['id']),
        title: _str(j['title']),
        duration: _str(j['duration']),
        durationMinutes: _int(j['durationMinutes']),
        lessonCount: _int(j['lessonCount']),
        rating: _double(j['rating']),
        hero: CourseHero.fromJson(_map(j['hero'])),
        tabs: CourseTabs.fromJson(_map(j['tabs'])),
        lessons: _list(j['lessons'], Lesson.fromJson),
        description: CourseDescription.fromJson(_map(j['description'])),
      );
}

class CourseHero {
  final String label;
  final String imageUrl;
  final String playIconUrl;
  final int videoCount;
  final int classCount;

  const CourseHero({
    required this.label,
    required this.imageUrl,
    required this.playIconUrl,
    required this.videoCount,
    required this.classCount,
  });

  factory CourseHero.fromJson(Map<String, dynamic> j) => CourseHero(
        label: _str(j['label']),
        imageUrl: _str(j['imageUrl']),
        playIconUrl: _str(j['playIconUrl']),
        videoCount: _int(j['videoCount']),
        classCount: _int(j['classCount']),
      );
}

class CourseTabs {
  final String selected;
  final List<CourseTab> items;

  const CourseTabs({required this.selected, required this.items});

  factory CourseTabs.fromJson(Map<String, dynamic> j) => CourseTabs(
        selected: _str(j['selected']),
        items: _list(j['items'], CourseTab.fromJson),
      );
}

class CourseTab {
  final String id;
  final String label;
  final bool selected;

  const CourseTab({
    required this.id,
    required this.label,
    required this.selected,
  });

  factory CourseTab.fromJson(Map<String, dynamic> j) => CourseTab(
        id: _str(j['id']),
        label: _str(j['label']),
        selected: j['selected'] as bool,
      );
}

class Lesson {
  final String id;
  final String title;
  final String duration;
  final int durationSeconds;
  final bool completed;
  final bool locked;
  final String playIconUrl;
  final String arrowIconUrl;

  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
    required this.playIconUrl,
    required this.arrowIconUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> j) => Lesson(
        id: _str(j['id']),
        title: _str(j['title']),
        duration: _str(j['duration']),
        durationSeconds: _int(j['durationSeconds']),
        completed: j['completed'] as bool,
        locked: j['locked'] as bool,
        playIconUrl: _str(j['playIconUrl']),
        arrowIconUrl: _str(j['arrowIconUrl']),
      );
}

class CourseDescription {
  final String text;

  const CourseDescription({required this.text});

  factory CourseDescription.fromJson(Map<String, dynamic> j) =>
      CourseDescription(text: _str(j['text']));
}

class CourseActions {
  final CoursePrice price;
  final EnrollAction enroll;

  const CourseActions({required this.price, required this.enroll});

  factory CourseActions.fromJson(Map<String, dynamic> j) => CourseActions(
        price: CoursePrice.fromJson(_map(j['price'])),
        enroll: EnrollAction.fromJson(_map(j['enroll'])),
      );
}

class CoursePrice {
  final String label;
  final double amount;
  final String currency;

  const CoursePrice({
    required this.label,
    required this.amount,
    required this.currency,
  });

  factory CoursePrice.fromJson(Map<String, dynamic> j) => CoursePrice(
        label: _str(j['label']),
        amount: _double(j['amount']),
        currency: _str(j['currency']),
      );
}

class EnrollAction {
  final String label;
  final bool enabled;

  const EnrollAction({required this.label, required this.enabled});

  factory EnrollAction.fromJson(Map<String, dynamic> j) => EnrollAction(
        label: _str(j['label']),
        enabled: j['enabled'] as bool,
      );
}

class UiIcons {
  final String durationIconUrl;
  final String lessonsIconUrl;
  final String ratingIconUrl;

  const UiIcons({
    required this.durationIconUrl,
    required this.lessonsIconUrl,
    required this.ratingIconUrl,
  });

  factory UiIcons.fromJson(Map<String, dynamic> j) => UiIcons(
        durationIconUrl: _str(j['durationIconUrl']),
        lessonsIconUrl: _str(j['lessonsIconUrl']),
        ratingIconUrl: _str(j['ratingIconUrl']),
      );
}

// ---------------------------------------------------------------------------
// Model derivat pentru lista de cursuri din home.
//
// JSON-ul are un singur curs detaliat (courseOverviewPage.course) plus doua
// elemente in learningPlan. Le unificam intr-o lista pentru căutare / filtrare /
// sortare / favorite, fara sa inventam date in fisierul JSON.
// ---------------------------------------------------------------------------

enum CourseCategory { design, development }

extension CourseCategoryLabel on CourseCategory {
  String get label => switch (this) {
        CourseCategory.design => 'Design',
        CourseCategory.development => 'Development',
      };
}

class CourseSummary {
  final String id;
  final String title;
  final String subtitle;
  final CourseCategory category;
  final double progress;
  final int completed;
  final int total;
  final int? durationMinutes;
  final int? lessonCount;
  final double? rating;
  final String? heroImageUrl;
  final String? progressIconUrl;
  final bool isLearningPlan;

  const CourseSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
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

  bool get isCompleted => total > 0 && completed >= total;
}

List<CourseSummary> buildCourseSummaries(AppData data) {
  final course = data.overview.course;
  final summaries = <CourseSummary>[
    CourseSummary(
      id: course.id,
      title: course.title,
      subtitle: '${course.lessonCount} lessons • ${course.duration}',
      category: CourseCategory.development,
      progress: 0,
      completed: 0,
      total: course.lessonCount,
      durationMinutes: course.durationMinutes,
      lessonCount: course.lessonCount,
      rating: course.rating,
      heroImageUrl: course.hero.imageUrl,
    ),
  ];

  for (final item in data.home.learningPlan.items) {
    summaries.add(
      CourseSummary(
        id: item.id,
        title: item.title,
        subtitle: data.home.learningPlan.title,
        category: item.title.toLowerCase().contains('design')
            ? CourseCategory.design
            : CourseCategory.development,
        progress: item.progress,
        completed: item.completed,
        total: item.total,
        progressIconUrl: item.progressIconUrl,
        isLearningPlan: true,
      ),
    );
  }

  return summaries;
}
