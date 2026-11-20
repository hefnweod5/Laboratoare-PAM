import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/core/theme/app_theme.dart';
import 'package:lab4_lucian_varianta4/data/models/course_details_model.dart';
import 'package:lab4_lucian_varianta4/data/models/learning_feed_model.dart';
import 'package:lab4_lucian_varianta4/domain/entities/course_details.dart';
import 'package:lab4_lucian_varianta4/domain/entities/learning_feed.dart';
import 'package:lab4_lucian_varianta4/domain/repositories/learning_repository.dart';
import 'package:lab4_lucian_varianta4/domain/usecases/get_course_details.dart';
import 'package:lab4_lucian_varianta4/domain/usecases/get_learning_feed.dart';
import 'package:lab4_lucian_varianta4/presentation/cubit/home_cubit.dart';
import 'package:lab4_lucian_varianta4/presentation/pages/home_page.dart';

import 'helpers/fixtures.dart';

class _FakeRepository implements LearningRepository {
  @override
  Future<LearningFeed> getLearningFeed() async {
    return LearningFeedModel.fromJson(withoutImages(sampleFeedJson));
  }

  @override
  Future<CourseDetails> getCourseDetails() async {
    return CourseDetailsModel.fromJson(withoutImages(sampleDetailsJson));
  }
}

Future<void> _pumpHome(WidgetTester tester, {Size size = const Size(402, 1600)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repository = _FakeRepository();

  await tester.pumpWidget(
    BlocProvider(
      create: (_) => HomeCubit(
        getLearningFeed: GetLearningFeed(repository),
        getCourseDetails: GetCourseDetails(repository),
      )..load(),
      child: MaterialApp(
        theme: buildAppTheme(),
        home: const HomePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home-ul afișează secțiunile primite de la API', (tester) async {
    await _pumpHome(tester);

    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('46min / 60min'), findsOneWidget);
    expect(find.text('My courses'), findsNWidgets(2));
    expect(find.text('Packaging Design'), findsOneWidget);
    expect(find.text('Product Design'), findsOneWidget);
    expect(find.text('What do you want to learn today?'), findsOneWidget);
    expect(find.text('Meetup'), findsOneWidget);
    expect(
      find.text('Off-line exchange of learning experience'),
      findsOneWidget,
    );
  });

  testWidgets('tap pe un curs din plan deschide Course Plan', (tester) async {
    await _pumpHome(tester, size: const Size(402, 900));

    await tester.tap(find.text('Packaging Design'));
    await tester.pumpAndSettle();

    expect(find.text('40 din 48 lecții finalizate'), findsOneWidget);
  });

  testWidgets('tap pe cursul detaliat deschide Course Overview', (tester) async {
    await _pumpHome(tester, size: const Size(402, 900));

    await tester.tap(find.text('React Front To back'));
    await tester.pumpAndSettle();

    expect(find.text('Course Overview'), findsOneWidget);
    expect(find.text('6h 30min'), findsOneWidget);
    expect(find.text('Enroll Now'), findsOneWidget);
  });
}
