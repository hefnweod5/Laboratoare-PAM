import '../entities/article_page.dart';
import '../repositories/article_repository.dart';

/// Caz de utilizare: caută articole după un termen introdus de utilizator.
class SearchArticles {
  const SearchArticles(this._repository);

  final ArticleRepository _repository;

  Future<ArticlePage> call({required String query, required int limit}) {
    return _repository.searchArticles(query: query, limit: limit);
  }
}
