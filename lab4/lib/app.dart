import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'domain/repositories/learning_repository.dart';
import 'domain/usecases/get_course_details.dart';
import 'domain/usecases/get_learning_feed.dart';
import 'presentation/cubit/home_cubit.dart';
import 'presentation/pages/home_page.dart';

/// Rădăcina aplicației — designul din Laboratorul 3, datele din REST API.
///
/// Injectarea dependențelor se face aici: repository-ul vine din `main`, iar
/// cazurile de utilizare sunt construite o singură dată și oferite cubitului.
class LearningApp extends StatelessWidget {
  const LearningApp({super.key, required this.repository});

  final LearningRepository repository;

  @override
  Widget build(BuildContext context) {
    final getLearningFeed = GetLearningFeed(repository);
    final getCourseDetails = GetCourseDetails(repository);

    return BlocProvider(
      create: (_) => HomeCubit(
        getLearningFeed: getLearningFeed,
        getCourseDetails: getCourseDetails,
      )..load(),
      child: MaterialApp(
        title: 'Learning App — Lab 4',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const HomePage(),
      ),
    );
  }
}
