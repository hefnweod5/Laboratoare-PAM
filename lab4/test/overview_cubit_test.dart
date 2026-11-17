import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/features/learning/data/models/course_details_model.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/cubit/overview_cubit.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/models/filters.dart';

import 'helpers/fixtures.dart';

OverviewCubit _cubit() => OverviewCubit(
      CourseDetailsModel.fromJson(sampleDetailsJson),
    );

void main() {
  group('OverviewCubit', () {
    test('pornește pe tab-ul din răspunsul API', () {
      final cubit = _cubit();

      expect(cubit.state.tabId, 'lessons');
      expect(cubit.state.visibleLessons, hasLength(4));

      cubit.close();
    });

    test('schimbă tab-ul selectat', () {
      final cubit = _cubit();

      cubit.setTab('description');

      expect(cubit.state.tabId, 'description');

      cubit.close();
    });

    test('căutarea filtrează lecțiile', () {
      final cubit = _cubit();

      cubit.setQuery('understanding');

      expect(cubit.state.visibleLessons, hasLength(1));
      expect(cubit.state.visibleLessons.first.title, 'Understanding React');

      cubit.close();
    });

    test('filtrul de lecții blocată funcționează', () {
      final cubit = _cubit();

      cubit.setFilter(LessonFilter.locked);

      expect(cubit.state.visibleLessons, hasLength(1));
      expect(cubit.state.visibleLessons.first.title, 'Build React');

      cubit.close();
    });

    test('sortarea după durată pune lecția cea mai scurtă prima', () {
      final cubit = _cubit();

      cubit.setSort(LessonSort.duration);

      expect(cubit.state.visibleLessons.first.title, 'Introduction to React');

      cubit.close();
    });

    test('favoritele lecțiilor pot fi comutate', () {
      final cubit = _cubit();

      cubit.toggleFavorite('lesson-1');
      expect(cubit.state.favoriteLessonIds, contains('lesson-1'));

      cubit.toggleFavorite('lesson-1');
      expect(cubit.state.favoriteLessonIds, isNot(contains('lesson-1')));

      cubit.close();
    });

    test('resetFilters revine la starea inițială', () {
      final cubit = _cubit();

      cubit.setQuery('react');
      cubit.setFilter(LessonFilter.completed);
      cubit.setSort(LessonSort.title);
      cubit.resetFilters();

      expect(cubit.state.query, '');
      expect(cubit.state.filter, LessonFilter.all);
      expect(cubit.state.sort, LessonSort.order);

      cubit.close();
    });
  });
}
