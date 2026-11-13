import '../entities/article.dart';
import '../entities/article_page.dart';
import '../entities/article_sort.dart';

/// Contractul de acces la date, cunoscut de stratul `domain`.
abstract class ArticleRepository {
  Future<ArticlePage> getArticles({
    required int limit,
    required int skip,
    required ArticleSort sort,
  });

  Future<ArticlePage> searchArticles({
    required String query,
    required int limit,
  });

  Future<Article> getArticleById(int id);
}
