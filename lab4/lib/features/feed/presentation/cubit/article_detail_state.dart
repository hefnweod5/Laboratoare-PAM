import 'package:equatable/equatable.dart';

import '../../domain/entities/article.dart';

enum ArticleDetailStatus { initial, loading, success, failure }

class ArticleDetailState extends Equatable {
  const ArticleDetailState({
    this.status = ArticleDetailStatus.initial,
    this.article,
    this.errorMessage,
  });

  final ArticleDetailStatus status;
  final Article? article;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, article, errorMessage];
}
