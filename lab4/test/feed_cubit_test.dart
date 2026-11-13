import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/core/error/failures.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/entities/article.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/entities/article_page.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/entities/article_sort.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/repositories/article_repository.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/usecases/get_articles.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/usecases/search_articles.dart';
import 'package:lab4_lucian_varianta4/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:lab4_lucian_varianta4/features/feed/presentation/cubit/feed_state.dart';

Article _article(int id) {
  return Article(
    id: id,
    title: 'Articol $id',
    body: 'Conținutul articolului $id.',
    tags: const ['learning'],
    likes: 10 * id,
    dislikes: 1,
    views: 100 * id,
    userId: 7,
  );
}

class _FakeRepository implements ArticleRepository {
  _FakeRepository({List<Article>? articles, this.failure})
      : _articles =
            articles ?? List.generate(18, (index) => _article(index + 1));

  final List<Article> _articles;
  final Failure? failure;

  int articleCalls = 0;
  int searchCalls = 0;
  int lastSkip = 0;
  String? lastQuery;
  ArticleSort? lastSort;

  @override
  Future<ArticlePage> getArticles({
    required int limit,
    required int skip,
    required ArticleSort sort,
  }) async {
    articleCalls++;
    lastSkip = skip;
    lastSort = sort;
    if (failure != null) throw failure!;

    final items = _articles.skip(skip).take(limit).toList();
    return ArticlePage(
      items: items,
      total: _articles.length,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<ArticlePage> searchArticles({
    required String query,
    required int limit,
  }) async {
    searchCalls++;
    lastQuery = query;
    if (failure != null) throw failure!;

    final items = _articles
        .where(
          (article) =>
              article.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return ArticlePage(items: items, total: items.length, skip: 0, limit: limit);
  }

  @override
  Future<Article> getArticleById(int id) async {
    if (failure != null) throw failure!;
    return _articles.firstWhere((article) => article.id == id);
  }
}

void main() {
  late _FakeRepository repository;
  late FeedCubit cubit;

  setUp(() {
    repository = _FakeRepository();
    cubit = FeedCubit(
      getArticles: GetArticles(repository),
      searchArticles: SearchArticles(repository),
    );
  });

  tearDown(() => cubit.close());

  test('încarcă prima pagină și expune starea de succes', () async {
    await cubit.load();

    expect(cubit.state.status, FeedStatus.success);
    expect(cubit.state.articles, hasLength(FeedCubit.pageSize));
    expect(cubit.state.total, 18);
    expect(cubit.state.hasMore, isTrue);
    expect(repository.lastSkip, 0);
  });

  test('adaugă următoarea pagină la loadMore', () async {
    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.articles, hasLength(18));
    expect(cubit.state.hasMore, isFalse);
    expect(repository.lastSkip, FeedCubit.pageSize);
  });

  test('transformă eroarea de rețea în stare de failure', () async {
    final failingRepository = _FakeRepository(
      failure: const NetworkFailure('Fără conexiune la internet.'),
    );
    final failingCubit = FeedCubit(
      getArticles: GetArticles(failingRepository),
      searchArticles: SearchArticles(failingRepository),
    );

    await failingCubit.load();

    expect(failingCubit.state.status, FeedStatus.failure);
    expect(failingCubit.state.errorMessage, 'Fără conexiune la internet.');

    await failingCubit.close();
  });

  test('trimite opțiunea de sortare către repository', () async {
    await cubit.changeSort(ArticleSort.mostViewed);

    expect(cubit.state.sort, ArticleSort.mostViewed);
    expect(repository.lastSort, ArticleSort.mostViewed);
  });

  test('caută cu debounce și transmite termenul către API', () async {
    cubit.onQueryChanged('articol 3');
    expect(cubit.state.query, 'articol 3');

    await Future<void>.delayed(const Duration(milliseconds: 600));

    expect(repository.searchCalls, 1);
    expect(repository.lastQuery, 'articol 3');
    expect(cubit.state.status, FeedStatus.success);
    expect(cubit.state.articles, hasLength(1));
    expect(cubit.state.hasMore, isFalse);
  });

  test('salvează și elimină un articol din listă', () async {
    await cubit.load();
    final article = cubit.state.articles.first;

    cubit.toggleSaved(article);
    expect(cubit.state.isSaved(article.id), isTrue);
    expect(cubit.state.savedCount, 1);

    cubit.toggleSaved(article);
    expect(cubit.state.isSaved(article.id), isFalse);
    expect(cubit.state.savedCount, 0);
  });
}
