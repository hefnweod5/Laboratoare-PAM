import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/courses_cubit.dart';
import '../bloc/courses_state.dart';
import '../core/app_colors.dart';
import '../models/course_models.dart';
import '../widgets/app_image.dart';

/// Detalii pentru un curs provenit din "Learning Plan" (fără lecții detaliate
/// în JSON) — afișează progresul real din fișier.
class CoursePlanScreen extends StatelessWidget {
  final CourseSummary course;

  const CoursePlanScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        title: Text(
          course.subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: kInk,
          ),
        ),
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          final isFavorite =
              state is CoursesLoaded && state.favoriteIds.contains(course.id);
          final percent = (course.progress * 100).round();

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: course.progress.clamp(0, 1),
                            strokeWidth: 9,
                            backgroundColor: kFieldFill,
                            valueColor: const AlwaysStoppedAnimation(kOrange),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: kInk,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${course.completed} din ${course.total} lecții finalizate',
                      style: const TextStyle(fontSize: 12.5, color: kGrey),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (course.progressIconUrl != null) ...[
                          AppSvg(
                            url: course.progressIconUrl!,
                            size: 20,
                            fallback: Icons.timelapse_rounded,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Chip(
                          label: Text(course.category.label),
                          backgroundColor: kOrangeSoft,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: kOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? kRed : kGrey,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Salvează acest curs la favorite pentru a-l găsi mai repede.',
                        style: TextStyle(fontSize: 12.5, color: kInkSoft),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<CoursesCubit>().toggleFavorite(course.id),
                      child: Text(isFavorite ? 'Elimină' : 'Adaugă'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Acest element face parte din planul de învățare. '
                'Lecțiile detaliate sunt disponibile pentru cursul principal.',
                style: TextStyle(fontSize: 12.5, color: kGrey, height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }
}
