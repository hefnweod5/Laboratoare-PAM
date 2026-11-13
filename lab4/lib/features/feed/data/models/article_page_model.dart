import '../../domain/entities/article_page.dart';
import 'article_model.dart';

/// Modelul JSON al unei pagini de articole.
class ArticlePageModel extends ArticlePage {
  const ArticlePageModel({
    required super.items,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory ArticlePageModel.fromJson(Map<String, dynamic> json) {
    final items = <ArticleModel>[];
    final rawPosts = json['posts'];
    if (rawPosts is List) {
      for (final item in rawPosts) {
        if (item is Map) {
          items.add(ArticleModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return ArticlePageModel(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
    );
  }

  Map<String, dynamic> toJson() => {
        'posts': items
            .map((article) => ArticleModel.fromEntity(article).toJson())
            .toList(),
        'total': total,
        'skip': skip,
        'limit': limit,
      };
}
