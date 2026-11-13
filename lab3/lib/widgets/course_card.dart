import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/course_models.dart';
import 'app_image.dart';

/// Cardul unui curs din lista "My courses".
class CourseCard extends StatelessWidget {
  final CourseSummary course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (course.progress * 100).round();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(course: course),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: kInk,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavorite,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 19,
                            color: isFavorite ? kRed : kGreyLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: course.isLearningPlan
                                ? kOrangeSoft
                                : const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            course.category.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: course.isLearningPlan
                                  ? kOrange
                                  : const Color(0xFF2F6BFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            course.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: kGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: course.progress.clamp(0, 1),
                        minHeight: 5,
                        backgroundColor: kFieldFill,
                        valueColor: AlwaysStoppedAnimation(
                          course.isCompleted ? kGreen : kOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '${course.completed}/${course.total}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: kGrey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: kInkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final CourseSummary course;

  const _Thumbnail({required this.course});

  @override
  Widget build(BuildContext context) {
    final hero = course.heroImageUrl;
    if (hero != null) {
      return AppImage(
        url: hero,
        width: 74,
        height: 74,
        radius: BorderRadius.circular(14),
      );
    }
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: kOrangeSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: course.progressIconUrl != null
          ? AppSvg(
              url: course.progressIconUrl!,
              size: 26,
              fallback: Icons.menu_book_rounded,
            )
          : const Icon(Icons.menu_book_rounded, color: kOrange, size: 26),
    );
  }
}
