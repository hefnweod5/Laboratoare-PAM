import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../models/course_list_item.dart';

/// Detaliile unui element din Learning Plan (progres real din API).
class CoursePlanPage extends StatelessWidget {
  const CoursePlanPage({super.key, required this.course});

  final CourseListItem course;

  @override
  Widget build(BuildContext context) {
    final percent = (course.progress * 100).round();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final isFavorite = state.favoriteIds.contains(course.id);

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
                            color: kOrange,
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
                          label: Text(course.categoryLabel),
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
                          context.read<HomeCubit>().toggleFavorite(course.id),
                      child: Text(isFavorite ? 'Elimină' : 'Adaugă'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Acest element face parte din planul de învățare. '
                'Lecțiile detaliate sunt disponibile în Course Overview.',
                style: TextStyle(fontSize: 12.5, color: kGrey, height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }
}
