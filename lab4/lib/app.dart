import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/feed/domain/repositories/article_repository.dart';
import 'features/feed/domain/usecases/get_article_detail.dart';
import 'features/feed/domain/usecases/get_articles.dart';
import 'features/feed/domain/usecases/search_articles.dart';
import 'features/feed/presentation/cubit/feed_cubit.dart';
import 'features/feed/presentation/pages/feed_page.dart';

/// Rădăcina aplicației.
///
/// Injectarea dependențelor se face aici: repository-ul vine din `main`, iar
/// cazurile de utilizare sunt construite o singură dată și oferite cubitului.
class App extends StatelessWidget {
  const App({super.key, required this.repository});

  final ArticleRepository repository;

  @override
  Widget build(BuildContext context) {
    final getArticles = GetArticles(repository);
    final searchArticles = SearchArticles(repository);
    final getArticleDetail = GetArticleDetail(repository);

    return BlocProvider(
      create: (_) => FeedCubit(
        getArticles: getArticles,
        searchArticles: searchArticles,
      )..load(),
      child: MaterialApp(
        title: 'Readly',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: FeedPage(getArticleDetail: getArticleDetail),
      ),
    );
  }
}
