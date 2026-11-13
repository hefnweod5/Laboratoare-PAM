import 'package:equatable/equatable.dart';

import 'article.dart';

/// O pagină de articole, exact cum este descrisă de serviciul Web.
class ArticlePage extends Equatable {
  const ArticlePage({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Article> items;
  final int total;
  final int skip;
  final int limit;

  bool get hasMore => skip + items.length < total;

  @override
  List<Object?> get props => [items, total, skip, limit];
}
