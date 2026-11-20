import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/entities/course_details.dart';

/// Un rând din lista de lecții (reutilizabil, design din Laboratorul 3).
class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final Lesson lesson;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final locked = lesson.locked;

    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                AppSvg(
                  url: lesson.playIconUrl,
                  size: 34,
                  fallback: locked
                      ? Icons.lock_outline_rounded
                      : Icons.play_circle_outline_rounded,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            lesson.duration,
                            style: const TextStyle(fontSize: 11.5, color: kGrey),
                          ),
                          if (lesson.completed) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 13,
                              color: kGreen,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              'Finalizată',
                              style: TextStyle(fontSize: 11, color: kGreen),
                            ),
                          ],
                          if (locked) ...[
                            const SizedBox(width: 8),
                            const Text(
                              'Blocată',
                              style: TextStyle(fontSize: 11, color: kGrey),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onFavorite,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: isFavorite ? kRed : kGreyLight,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                AppSvg(
                  url: lesson.arrowIconUrl,
                  size: 22,
                  fallback: Icons.chevron_right_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
