import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/article_sort.dart';
import '../../domain/usecases/get_articles.dart';
import '../../domain/usecases/search_articles.dart';
import 'feed_state.dart';

/// Coordonează fluxul UI -> use case -> repository -> API și înapoi.
///
/// Nu cunoaște HTTP, JSON sau widget-uri: depinde doar de cazurile de
/// utilizare din `domain`.
class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required this.getArticles,
    required this.searchArticles,
  }) : super(const FeedState());

  final GetArticles getArticles;
  final SearchArticles searchArticles;

  static const int pageSize = ApiConstants.pageSize;

  Timer? _debounce;

  /// Identificatorul ultimei cereri, pentru a ignora răspunsurile întârziate.
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    final searching = state.query.isNotEmpty;

    emit(
      state.copyWith(
        status: FeedStatus.loading,
        articles: const [],
        total: 0,
        hasMore: false,
        isLoadingMore: false,
        loadMoreFailed: false,
        clearError: true,
      ),
    );

    try {
      final page = searching
          ? await searchArticles(query: state.query, limit: 100)
          : await getArticles(limit: pageSize, skip: 0, sort: state.sort);

      if (isClosed || requestId != _requestId) return;

      emit(
        state.copyWith(
          status: FeedStatus.success,
          articles: page.items,
          total: page.total,
          hasMore: searching ? false : page.hasMore,
          clearError: true,
        ),
      );
    } on Failure catch (failure) {
      if (isClosed || requestId != _requestId) return;
      emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> refresh() => load();

  Future<void> retry() => load();

  /// Încarcă următoarea pagină la scroll.
  Future<void> loadMore() async {
    if (state.status != FeedStatus.success ||
        state.isLoadingMore ||
        !state.hasMore ||
        state.query.isNotEmpty) {
      return;
    }

    final requestId = _requestId;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    try {
      final page = await getArticles(
        limit: pageSize,
        skip: state.articles.length,
        sort: state.sort,
      );

      if (isClosed || requestId != _requestId) return;

      emit(
        state.copyWith(
          articles: [...state.articles, ...page.items],
          total: page.total,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } on Failure catch (failure) {
      if (isClosed || requestId != _requestId) return;
      emit(
        state.copyWith(
          isLoadingMore: false,
          loadMoreFailed: true,
          errorMessage: failure.message,
        ),
      );
    }
  }

  /// Caută cu debounce, ca să nu trimitem o cerere la fiecare tastă.
  void onQueryChanged(String value) {
    final query = value.trim();
    if (query == state.query) return;

    emit(state.copyWith(query: query, clearError: true));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), load);
  }

  Future<void> clearQuery() async {
    _debounce?.cancel();
    if (state.query.isEmpty) return;
    emit(state.copyWith(query: '', clearError: true));
    await load();
  }

  Future<void> changeSort(ArticleSort sort) async {
    if (sort == state.sort) return;
    emit(state.copyWith(sort: sort));
    await load();
  }

  void toggleSaved(Article article) {
    final saved = [...state.saved];
    if (state.isSaved(article.id)) {
      saved.removeWhere((item) => item.id == article.id);
    } else {
      saved.insert(0, article);
    }
    emit(state.copyWith(saved: saved));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
