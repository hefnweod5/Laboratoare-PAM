import '../../domain/entities/article.dart';

/// Modelul JSON al unui articol.
///
/// Aici are loc deserializarea (`fromJson`) și serializarea (`toJson`).
/// Restul aplicației lucrează cu entitatea `Article`.
class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.likes,
    required super.dislikes,
    required super.views,
    required super.userId,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final tags = <String>[];
    final rawTags = json['tags'];
    if (rawTags is List) {
      for (final item in rawTags) {
        if (item is String) tags.add(item);
      }
    }

    var likes = 0;
    var dislikes = 0;
    final reactions = json['reactions'];
    if (reactions is Map) {
      likes = (reactions['likes'] as num?)?.toInt() ?? 0;
      dislikes = (reactions['dislikes'] as num?)?.toInt() ?? 0;
    }

    return ArticleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Articol fără titlu',
      body: json['body'] as String? ?? '',
      tags: tags,
      likes: likes,
      dislikes: dislikes,
      views: (json['views'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
    );
  }

  /// Reconstruiește modelul dintr-o entitate (folosit la serializare).
  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      body: article.body,
      tags: article.tags,
      likes: article.likes,
      dislikes: article.dislikes,
      views: article.views,
      userId: article.userId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'tags': tags,
        'reactions': {
          'likes': likes,
          'dislikes': dislikes,
        },
        'views': views,
        'userId': userId,
      };
}
