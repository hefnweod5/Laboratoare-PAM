import '../entities/article.dart';
import '../repositories/article_repository.dart';

/// Caz de utilizare: încarcă articolul complet.
class GetArticleDetail {
  const GetArticleDetail(this._repository);

  final ArticleRepository _repository;

  Future<Article> call(int id) => _repository.getArticleById(id);
}
