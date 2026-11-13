import '../entities/article_page.dart';
import '../entities/article_sort.dart';
import '../repositories/article_repository.dart';

/// Caz de utilizare: încarcă o pagină din feed.
class GetArticles {
  const GetArticles(this._repository);

  final ArticleRepository _repository;

  Future<ArticlePage> call({
    required int limit,
    required int skip,
    ArticleSort sort = ArticleSort.newest,
  }) {
    return _repository.getArticles(limit: limit, skip: skip, sort: sort);
  }
}
