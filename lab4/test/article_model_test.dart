import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/features/feed/data/models/article_model.dart';
import 'package:lab4_lucian_varianta4/features/feed/data/models/article_page_model.dart';

void main() {
  const sampleJson = <String, dynamic>{
    'id': 1,
    'title': 'His mother had always taught him',
    'body':
        'His mother had always taught him not to ever think of himself as '
            'better than others. He never looked down on those who had less.',
    'tags': ['history', 'american', 'crime'],
    'reactions': {'likes': 192, 'dislikes': 25},
    'views': 305,
    'userId': 121,
  };

  group('ArticleModel', () {
    test('deserializează corect răspunsul JSON', () {
      final article = ArticleModel.fromJson(sampleJson);

      expect(article.id, 1);
      expect(article.title, 'His mother had always taught him');
      expect(article.tags, hasLength(3));
      expect(article.likes, 192);
      expect(article.dislikes, 25);
      expect(article.views, 305);
      expect(article.userId, 121);
    });

    test('calculează numărul de cuvinte și timpul de lectură', () {
      final article = ArticleModel.fromJson(sampleJson);

      expect(article.wordCount, greaterThan(20));
      expect(article.readingMinutes, 1);
    });

    test('estimează minimum un minut pentru un articol gol', () {
      final article = ArticleModel.fromJson(const {'id': 2});

      expect(article.wordCount, 0);
      expect(article.readingMinutes, 1);
      expect(article.title, 'Articol fără titlu');
      expect(article.tags, isEmpty);
    });

    test('serializează articolul înapoi în JSON', () {
      final article = ArticleModel.fromJson(sampleJson);
      final json = article.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'His mother had always taught him');
      expect(json['tags'], hasLength(3));
      expect(json['reactions'], containsPair('likes', 192));
      expect(json['views'], 305);
      expect(json['userId'], 121);
    });

    test('acceptă valori lipsă fără să arunce excepții', () {
      final article = ArticleModel.fromJson(const {});

      expect(article.id, 0);
      expect(article.body, '');
      expect(article.likes, 0);
      expect(article.dislikes, 0);
      expect(article.views, 0);
    });
  });

  group('ArticlePageModel', () {
    test('deserializează lista de articole și metadatele paginii', () {
      final page = ArticlePageModel.fromJson(const {
        'posts': [sampleJson],
        'total': 251,
        'skip': 0,
        'limit': 10,
      });

      expect(page.items, hasLength(1));
      expect(page.total, 251);
      expect(page.skip, 0);
      expect(page.limit, 10);
      expect(page.hasMore, isTrue);
    });

    test('serializează pagina înapoi în JSON', () {
      final page = ArticlePageModel.fromJson(const {
        'posts': [sampleJson],
        'total': 251,
        'skip': 0,
        'limit': 10,
      });

      final json = page.toJson();

      expect(json['posts'], hasLength(1));
      expect(json['total'], 251);
      expect((json['posts'] as List).first, containsPair('id', 1));
    });
  });
}
