import '../../../../core/network/api_client.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/article_page.dart';
import '../../domain/entities/article_sort.dart';
import '../models/article_model.dart';
import '../models/article_page_model.dart';

/// Sursa de date remote: singurul loc care cunoaște rutele serviciului Web.
abstract class ArticleRemoteDataSource {
  Future<ArticlePage> fetchArticles({
    required int limit,
    required int skip,
    required ArticleSort sort,
  });

  Future<ArticlePage> searchArticles({
    required String query,
    required int limit,
  });

  Future<Article> fetchArticleById(int id);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  ArticleRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<ArticlePage> fetchArticles({
    required int limit,
    required int skip,
    required ArticleSort sort,
  }) async {
    final query = <String, String>{
      'limit': '$limit',
      'skip': '$skip',
    };
    if (sort.sortBy != null) {
      query['sortBy'] = sort.sortBy!;
      query['order'] = sort.order!;
    }

    final json = await _client.getJson('/posts', query: query);
    return ArticlePageModel.fromJson(json);
  }

  @override
  Future<ArticlePage> searchArticles({
    required String query,
    required int limit,
  }) async {
    final json = await _client.getJson(
      '/posts/search',
      query: {'q': query, 'limit': '$limit'},
    );
    return ArticlePageModel.fromJson(json);
  }

  @override
  Future<Article> fetchArticleById(int id) async {
    final json = await _client.getJson('/posts/$id');
    return ArticleModel.fromJson(json);
  }
}
