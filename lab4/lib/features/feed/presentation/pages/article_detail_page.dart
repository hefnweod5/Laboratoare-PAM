import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/article.dart';
import '../cubit/article_detail_cubit.dart';
import '../cubit/article_detail_state.dart';
import '../cubit/feed_cubit.dart';
import '../widgets/meta_label.dart';
import '../widgets/tag_chip.dart';

/// Ecranul de lectură, alimentat asincron de la serviciul Web.
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.preview});

  /// Articolul din feed, afișat imediat până sosesc detaliile complete.
  final Article preview;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
      builder: (context, state) {
        if (state.status == ArticleDetailStatus.failure &&
            state.article == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Articol')),
            body: ErrorView(
              message:
                  state.errorMessage ?? 'Articolul nu a putut fi încărcat.',
              onRetry: () =>
                  context.read<ArticleDetailCubit>().load(preview.id),
            ),
          );
        }

        final article = state.article ?? preview;
        final isLoading = state.status == ArticleDetailStatus.loading;
        final isSaved =
            context.watch<FeedCubit>().state.isSaved(article.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                backgroundColor: kBackground,
                surfaceTintColor: Colors.transparent,
                leadingWidth: 60,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: _CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  _CircleIconButton(
                    icon: isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved ? kIndigo : kInk,
                    onTap: () =>
                        context.read<FeedCubit>().toggleSaved(article),
                  ),
                  const SizedBox(width: 14),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _ArticleHero(article: article),
                ),
              ),
              if (isLoading)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(
                    minHeight: 2.5,
                    color: kIndigo,
                    backgroundColor: kFieldFill,
                  ),
                ),
              SliverToBoxAdapter(child: _ArticleBody(article: article)),
            ],
          ),
          bottomNavigationBar: _SaveBar(article: article),
        );
      },
    );
  }
}

class _ArticleHero extends StatelessWidget {
  const _ArticleHero({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kIndigoDark, kIndigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.paddingOf(context).top + 64,
        24,
        22,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: article.tags
                .take(3)
                .map((tag) => TagChip(label: tag, onDark: true))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              MetaLabel(
                icon: Icons.person_outline_rounded,
                text: article.authorLabel,
                onDark: true,
              ),
              MetaLabel(
                icon: Icons.schedule_rounded,
                text: '${article.readingMinutes} min',
                onDark: true,
              ),
              MetaLabel(
                icon: Icons.visibility_outlined,
                text: formatCompact(article.views),
                onDark: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.favorite_rounded,
                  label: 'Aprecieri',
                  value: formatCompact(article.likes),
                  color: kIndigo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.visibility_rounded,
                  label: 'Vizualizări',
                  value: formatCompact(article.views),
                  color: kIndigoSoft,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.thumb_down_alt_rounded,
                  label: 'Neaprecieri',
                  value: formatCompact(article.dislikes),
                  color: kMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel(text: 'Conținut'),
          const SizedBox(height: 10),
          Text(
            article.body,
            style: const TextStyle(
              fontSize: 14,
              color: kInkSoft,
              height: 1.7,
            ),
          ),
          if (article.tags.isNotEmpty) ...[
            const SizedBox(height: 24),
            const _SectionLabel(text: 'Subiecte'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: article.tags
                  .map((tag) => TagChip(label: tag))
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kFieldFill),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: kLavender,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: kIndigo,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.authorLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Articol din colecția Readly',
                        style: TextStyle(fontSize: 11.5, color: kMuted),
                      ),
                    ],
                  ),
                ),
                MetaLabel(
                  icon: Icons.schedule_rounded,
                  text: '${article.readingMinutes} min',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kFieldFill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: kMuted),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: kIndigo,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: kInk,
          ),
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final isSaved = context.watch<FeedCubit>().state.isSaved(article.id);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: kCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () => context.read<FeedCubit>().toggleSaved(article),
              icon: Icon(
                isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 19,
              ),
              label: Text(isSaved ? 'Salvat' : 'Salvează articolul'),
              style: FilledButton.styleFrom(
                backgroundColor: isSaved ? kLavender : kIndigo,
                foregroundColor: isSaved ? kIndigo : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Link copiat în clipboard.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: kInk,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
            },
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: const Text('Distribuie'),
            style: OutlinedButton.styleFrom(
              foregroundColor: kInk,
              side: const BorderSide(color: kFieldFill),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.color = kInk,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
