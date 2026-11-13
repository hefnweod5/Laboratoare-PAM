import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/article.dart';
import 'meta_label.dart';
import 'tag_chip.dart';

/// Cardul unui articol din feed.
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.position,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
  });

  final Article article;
  final int position;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kLavender,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  position.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: kIndigo,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: article.previewTags
                          .map((tag) => TagChip(label: tag))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        MetaLabel(
                          icon: Icons.schedule_rounded,
                          text: '${article.readingMinutes} min',
                        ),
                        MetaLabel(
                          icon: Icons.visibility_outlined,
                          text: formatCompact(article.views),
                        ),
                        MetaLabel(
                          icon: Icons.favorite_border_rounded,
                          text: formatCompact(article.likes),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleSaved,
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 20,
                  color: isSaved ? kIndigo : kMutedLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
