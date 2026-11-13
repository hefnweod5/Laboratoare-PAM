import 'package:equatable/equatable.dart';

import '../../domain/entities/article.dart';
import '../../domain/entities/article_sort.dart';

enum FeedStatus { initial, loading, success, failure }

/// Starea feed-ului de articole.
///
/// Este imutabilă: fiecare schimbare produce o stare nouă.
class FeedState extends Equatable {
  const FeedState({
    this.status = FeedStatus.initial,
    this.articles = const [],
    this.total = 0,
    this.query = '',
    this.sort = ArticleSort.newest,
    this.saved = const [],
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreFailed = false,
  });

  final FeedStatus status;
  final List<Article> articles;
  final int total;
  final String query;
  final ArticleSort sort;
  final List<Article> saved;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool hasMore;
  final bool loadMoreFailed;

  bool get isEmpty => status == FeedStatus.success && articles.isEmpty;

  bool get isSearching => query.isNotEmpty;

  int get savedCount => saved.length;

  bool isSaved(int articleId) =>
      saved.any((article) => article.id == articleId);

  FeedState copyWith({
    FeedStatus? status,
    List<Article>? articles,
    int? total,
    String? query,
    ArticleSort? sort,
    List<Article>? saved,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingMore,
    bool? hasMore,
    bool? loadMoreFailed,
  }) {
    return FeedState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      total: total ?? this.total,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      saved: saved ?? this.saved,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        articles,
        total,
        query,
        sort,
        saved,
        errorMessage,
        isLoadingMore,
        hasMore,
        loadMoreFailed,
      ];
}
