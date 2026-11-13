import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/overview_cubit.dart';
import '../bloc/overview_state.dart';
import '../core/app_colors.dart';
import '../models/course_models.dart';
import '../widgets/app_image.dart';

/// Detaliile unei lecții.
class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        title: const Text(
          'Lecție',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: kInk,
          ),
        ),
      ),
      body: BlocBuilder<CourseOverviewCubit, OverviewState>(
        builder: (context, state) {
          final isFavorite = state.favoriteLessonIds.contains(lesson.id);
          final cubit = context.read<CourseOverviewCubit>();

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    AppSvg(
                      url: lesson.playIconUrl,
                      size: 64,
                      fallback: Icons.play_circle_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lesson.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.duration,
                      style: const TextStyle(fontSize: 13, color: kGrey),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _StatusChip(
                          label: lesson.completed ? 'Finalizată' : 'În progres',
                          color: lesson.completed ? kGreen : kOrange,
                          background: lesson.completed
                              ? const Color(0xFFE7F7EF)
                              : kOrangeSoft,
                        ),
                        if (lesson.locked)
                          const _StatusChip(
                            label: 'Blocată',
                            color: kGrey,
                            background: kFieldFill,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => cubit.toggleFavorite(lesson.id),
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite ? kRed : kGrey,
                      ),
                      label: Text(isFavorite ? 'La favorite' : 'Adaugă la favorite'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: lesson.locked
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Redare: ${lesson.title}'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text('Redă'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
