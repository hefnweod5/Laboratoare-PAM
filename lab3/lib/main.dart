import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/courses_cubit.dart';
import 'core/app_colors.dart';
import 'data/course_repository.dart';
import 'screens/home_screen.dart';

void main() => runApp(const LearnApp());

/// Laborator 3 - Varianta 4 (Lucian)
/// State management: flutter_bloc (Cubit). Date: assets/data/courses.json.
class LearnApp extends StatelessWidget {
  const LearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesCubit(CourseRepository())..load(),
      child: MaterialApp(
        title: 'Learning App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: kOrange,
          scaffoldBackgroundColor: kBg,
          appBarTheme: const AppBarTheme(
            backgroundColor: kBg,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
