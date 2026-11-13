import 'package:equatable/equatable.dart';

/// Entitatea de business a unui articol.
///
/// Nu depinde de JSON, HTTP sau Flutter; este folosită identic de straturile
/// `data` și `presentation`.
class Article extends Equatable {
  const Article({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });

  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  /// Numărul de cuvinte, folosit pentru estimarea timpului de lectură.
  int get wordCount {
    final text = body.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  /// Estimare la ~200 de cuvinte pe minut, minimum un minut.
  int get readingMinutes {
    if (wordCount == 0) return 1;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  String get authorLabel => 'Autor #$userId';

  /// Primele două etichete, folosite în cardul din feed.
  List<String> get previewTags => tags.take(2).toList();

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        tags,
        likes,
        dislikes,
        views,
        userId,
      ];
}
