import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/article_page.dart';
import '../../domain/entities/article_sort.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_data_source.dart';

/// Implementarea contractului din `domain`.
///
/// Traduce orice eroare neașteptată (inclusiv JSON invalid) într-un `Failure`.
class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(this._remoteDataSource);

  final ArticleRemoteDataSource _remoteDataSource;

  @override
  Future<ArticlePage> getArticles({
    required int limit,
    required int skip,
    required ArticleSort sort,
  }) async {
    try {
      return await _remoteDataSource.fetchArticles(
        limit: limit,
        skip: skip,
        sort: sort,
      );
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ParseFailure('Articolele primite nu au putut fi citite.');
    }
  }

  @override
  Future<ArticlePage> searchArticles({
    required String query,
    required int limit,
  }) async {
    try {
      return await _remoteDataSource.searchArticles(
        query: query,
        limit: limit,
      );
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ParseFailure('Rezultatele căutării nu au putut fi citite.');
    }
  }

  @override
  Future<Article> getArticleById(int id) async {
    try {
      return await _remoteDataSource.fetchArticleById(id);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ParseFailure('Articolul nu a putut fi citit.');
    }
  }
}
