import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/core/theme/app_theme.dart';
import 'package:lab4_lucian_varianta4/features/learning/data/models/course_details_model.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/cubit/overview_cubit.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/pages/course_overview_page.dart';

import 'helpers/fixtures.dart';

Future<void> _pumpPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final details = CourseDetailsModel.fromJson(withoutImages(sampleDetailsJson));

  await tester.pumpWidget(
    BlocProvider(
      create: (_) => OverviewCubit(details),
      child: MaterialApp(
        theme: buildAppTheme(),
        home: CourseOverviewPage(details: details),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Course Overview afișează datele cursului', (tester) async {
    await _pumpPage(tester);

    expect(find.text('Course Overview'), findsOneWidget);
    expect(find.text('React Front To back'), findsOneWidget);
    expect(find.text('6h 30min'), findsOneWidget);
    expect(find.text('7 lessons'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('Lessons'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Introduction to React'), findsOneWidget);
    expect(find.text('Understanding React'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Enroll Now'), findsOneWidget);
  });

  testWidgets('tab-ul Description afișează starea goală', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Description'));
    await tester.pumpAndSettle();

    expect(find.text('Fără descriere'), findsOneWidget);
    expect(find.text('Introduction to React'), findsNothing);
  });

  testWidgets('butonul Enroll afișează confirmarea', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Enroll Now'));
    await tester.pump();

    expect(
      find.textContaining('te-ai înscris la curs'),
      findsOneWidget,
    );
  });

  testWidgets('tap pe o lecție deschide Lesson Detail', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Introduction to React'));
    await tester.pumpAndSettle();

    expect(find.text('Introduction to React'), findsNWidgets(1));
    expect(find.text('Finalizată'), findsNothing);
  });
}
