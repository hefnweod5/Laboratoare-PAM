import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/core/error/failures.dart';
import 'package:lab4_lucian_varianta4/features/learning/data/models/course_details_model.dart';
import 'package:lab4_lucian_varianta4/features/learning/data/models/learning_feed_model.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/entities/course_details.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/entities/learning_feed.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/repositories/learning_repository.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/usecases/get_course_details.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/usecases/get_learning_feed.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/cubit/home_cubit.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/cubit/home_state.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/models/filters.dart';

import 'helpers/fixtures.dart';

class _FakeRepository implements LearningRepository {
  _FakeRepository({this.failure});

  final Failure? failure;
  int feedCalls = 0;
  int detailsCalls = 0;

  @override
  Future<LearningFeed> getLearningFeed() async {
    feedCalls++;
    if (failure != null) throw failure!;
    return LearningFeedModel.fromJson(sampleFeedJson);
  }

  @override
  Future<CourseDetails> getCourseDetails() async {
    detailsCalls++;
    if (failure != null) throw failure!;
    return CourseDetailsModel.fromJson(sampleDetailsJson);
  }
}

HomeCubit _cubit(_FakeRepository repository) => HomeCubit(
      getLearningFeed: GetLearningFeed(repository),
      getCourseDetails: GetCourseDetails(repository),
    );

void main() {
  group('HomeCubit', () {
    test('încarcă feed-ul și detaliile în paralel și construiește lista',
        () async {
      final repository = _FakeRepository();
      final cubit = _cubit(repository);
      final statuses = <HomeStatus>[];
      final subscription = cubit.stream.listen((state) {
        statuses.add(state.status);
      });

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(statuses, [HomeStatus.loading, HomeStatus.success]);
      expect(cubit.state.feed, isNotNull);
      expect(cubit.state.details, isNotNull);
      expect(repository.feedCalls, 1);
      expect(repository.detailsCalls, 1);

      // Cursul detaliat + cele două elemente din Learning Plan.
      expect(cubit.state.visibleCourses, hasLength(3));

      await subscription.cancel();
      await cubit.close();
    });

    test('transformă eroarea de rețea în stare de failure', () async {
      final repository = _FakeRepository(
        failure: const NetworkFailure('Fără conexiune la internet.'),
      );
      final cubit = _cubit(repository);

      await cubit.load();

      expect(cubit.state.status, HomeStatus.failure);
      expect(cubit.state.errorMessage, 'Fără conexiune la internet.');

      await cubit.close();
    });

    test('retry-ul reia ambele cereri', () async {
      final repository = _FakeRepository();
      final cubit = _cubit(repository);

      await cubit.load();
      await cubit.refresh();

      expect(repository.feedCalls, 2);
      expect(repository.detailsCalls, 2);

      await cubit.close();
    });

    test('căutarea filtrează lista de cursuri', () async {
      final cubit = _cubit(_FakeRepository());
      await cubit.load();

      cubit.setQuery('packaging');

      expect(cubit.state.visibleCourses, hasLength(1));
      expect(cubit.state.visibleCourses.first.title, 'Packaging Design');

      await cubit.close();
    });

    test('filtrul Design afișează doar cursurile de design', () async {
      final cubit = _cubit(_FakeRepository());
      await cubit.load();

      cubit.setFilter('design');

      expect(cubit.state.visibleCourses, hasLength(2));
      expect(
        cubit.state.visibleCourses.every(
          (item) => item.categoryLabel == 'Design',
        ),
        isTrue,
      );

      await cubit.close();
    });

    test('sortarea după progres pune cursul cel mai avansat primul', () async {
      final cubit = _cubit(_FakeRepository());
      await cubit.load();

      cubit.setSort(CourseSort.progress);

      expect(cubit.state.visibleCourses.first.title, 'Packaging Design');

      await cubit.close();
    });

    test('favoritele pot fi adăugate și eliminate', () async {
      final cubit = _cubit(_FakeRepository());
      await cubit.load();

      cubit.toggleFavorite('packaging-design');
      expect(cubit.state.favoriteIds, contains('packaging-design'));

      cubit.toggleFavorite('packaging-design');
      expect(cubit.state.favoriteIds, isNot(contains('packaging-design')));

      await cubit.close();
    });

    test('resetFilters revine la starea inițială', () async {
      final cubit = _cubit(_FakeRepository());
      await cubit.load();

      cubit.setQuery('react');
      cubit.setFilter('development');
      cubit.setSort(CourseSort.lessons);
      cubit.resetFilters();

      expect(cubit.state.query, '');
      expect(cubit.state.filterId, 'all');
      expect(cubit.state.sort, CourseSort.title);

      await cubit.close();
    });
  });
}
