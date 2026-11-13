import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/article.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';
import 'meta_label.dart';
import 'tag_chip.dart';

/// Deschide lista articolelor salvate.
Future<void> showSavedSheet(
  BuildContext context, {
  required ValueChanged<Article> onOpen,
}) {
  final cubit = context.read<FeedCubit>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: kCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: _SavedSheetBody(onOpen: onOpen),
      );
    },
  );
}

class _SavedSheetBody extends StatelessWidget {
  const _SavedSheetBody({required this.onOpen});

  final ValueChanged<Article> onOpen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        final saved = state.saved;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kFieldFill,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Salvate',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${saved.length} articole',
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (saved.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: kLavender,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_border_rounded,
                            color: kIndigo,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Niciun articol salvat încă',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: kInk,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Apasă semnul de carte pentru a păstra un articol aici.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: kMuted),
                        ),
                      ],
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: saved.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 18, color: kFieldFill),
                      itemBuilder: (context, index) {
                        final article = saved[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            onOpen(article);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    const SizedBox(height: 6),
                                    Text(
                                      article.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: kInk,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    MetaLabel(
                                      icon: Icons.schedule_rounded,
                                      text: '${article.readingMinutes} min',
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<FeedCubit>()
                                    .toggleSaved(article),
                                icon: const Icon(
                                  Icons.bookmark_rounded,
                                  color: kIndigo,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
