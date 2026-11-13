import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/features/feed/domain/entities/article.dart';
import 'package:lab4_lucian_varianta4/features/feed/presentation/widgets/article_card.dart';

void main() {
  const article = Article(
    id: 1,
    title: 'His mother had always taught him',
    body: 'His mother had always taught him not to ever think of himself.',
    tags: ['history', 'american'],
    likes: 192,
    dislikes: 25,
    views: 305,
    userId: 121,
  );

  testWidgets('afișează datele articolului și reacționează la acțiuni',
      (tester) async {
    var savedTaps = 0;
    var cardTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 340,
              child: ArticleCard(
                article: article,
                position: 1,
                isSaved: false,
                onTap: () => cardTaps++,
                onToggleSaved: () => savedTaps++,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('His mother had always taught him'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('history'), findsOneWidget);
    expect(find.text('1 min'), findsOneWidget);
    expect(find.text('305'), findsOneWidget);
    expect(find.text('192'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    expect(savedTaps, 1);

    await tester.tap(find.text('His mother had always taught him'));
    expect(cardTaps, 1);
  });

  testWidgets('afișează starea de articol salvat', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 340,
            child: ArticleCard(
              article: article,
              position: 2,
              isSaved: true,
              onTap: () {},
              onToggleSaved: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
  });
}
