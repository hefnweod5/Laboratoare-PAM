import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_article_detail.dart';
import '../cubit/article_detail_cubit.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';
import '../widgets/article_card.dart';
import '../widgets/feed_header.dart';
import '../widgets/feed_search_field.dart';
import '../widgets/saved_sheet.dart';
import '../widgets/sort_sheet.dart';
import 'article_detail_page.dart';

/// Ecranul principal: feed-ul de articole.
class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.getArticleDetail});

  final GetArticleDetail getArticleDetail;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 420) {
      context.read<FeedCubit>().loadMore();
    }
  }

  void _openArticle(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              ArticleDetailCubit(widget.getArticleDetail)..load(article.id),
          child: ArticleDetailPage(preview: article),
        ),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<FeedCubit>().clearQuery();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedCubit>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<FeedCubit, FeedState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: kIndigo,
              onRefresh: cubit.refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          FeedHeader(
                            articleCount: state.total,
                            savedCount: state.savedCount,
                            onOpenSaved: () => showSavedSheet(
                              context,
                              onOpen: _openArticle,
                            ),
                          ),
                          const SizedBox(height: 18),
                          FeedSearchField(
                            controller: _searchController,
                            onChanged: cubit.onQueryChanged,
                            onClear: _clearSearch,
                          ),
                          const SizedBox(height: 14),
                          _FeedToolbar(
                            state: state,
                            onSort: () => showSortSheet(
                              context,
                              current: state.sort,
                              onSelected: cubit.changeSort,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ..._buildContent(state, cubit),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildContent(FeedState state, FeedCubit cubit) {
    if (state.status == FeedStatus.initial ||
        state.status == FeedStatus.loading) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: LoadingView(),
          ),
        ),
      ];
    }

    if (state.status == FeedStatus.failure) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            message: state.errorMessage ?? 'Feed-ul nu a putut fi încărcat.',
            onRetry: cubit.retry,
          ),
        ),
      ];
    }

    if (state.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyView(
            title: state.isSearching
                ? 'Niciun articol găsit'
                : 'Feed-ul este gol',
            message: state.isSearching
                ? 'Nu am găsit articole pentru „${state.query}”. Încearcă alt termen.'
                : 'Momentan nu există articole disponibile.',
            actionLabel: 'Resetează căutarea',
            onAction: state.isSearching ? _clearSearch : null,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        sliver: SliverList.builder(
          itemCount: state.articles.length,
          itemBuilder: (context, index) {
            final article = state.articles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ArticleCard(
                article: article,
                position: index + 1,
                isSaved: state.isSaved(article.id),
                onTap: () => _openArticle(article),
                onToggleSaved: () => cubit.toggleSaved(article),
              ),
            );
          },
        ),
      ),
      SliverToBoxAdapter(child: _buildFooter(state, cubit)),
    ];
  }

  Widget _buildFooter(FeedState state, FeedCubit cubit) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    if (state.loadMoreFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              state.errorMessage ?? 'Încărcarea a eșuat.',
              style: const TextStyle(fontSize: 12, color: kMuted),
            ),
            TextButton(
              onPressed: cubit.loadMore,
              child: const Text('Reîncearcă'),
            ),
          ],
        ),
      );
    }

    if (state.isSearching) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Text(
          '${state.total} rezultate pentru „${state.query}”',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11.5, color: kMuted),
        ),
      );
    }

    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Text(
          'Ai ajuns la finalul feed-ului',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.5, color: kMuted),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _FeedToolbar extends StatelessWidget {
  const _FeedToolbar({required this.state, required this.onSort});

  final FeedState state;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.isSearching ? 'Rezultate' : 'Articole',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                state.isSearching
                    ? '${state.total} pentru „${state.query}”'
                    : '${state.total} articole disponibile',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5, color: kMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: OutlinedButton.icon(
            onPressed: onSort,
            icon: const Icon(Icons.swap_vert_rounded, size: 17),
            label: Text(
              state.sort.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: kInk,
              backgroundColor: kCard,
              side: const BorderSide(color: kFieldFill),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
