import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_article_detail.dart';
import 'article_detail_state.dart';

/// Încarcă articolul complet direct de la serviciul Web.
class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  ArticleDetailCubit(this._getArticleDetail)
      : super(const ArticleDetailState());

  final GetArticleDetail _getArticleDetail;

  Future<void> load(int id) async {
    emit(const ArticleDetailState(status: ArticleDetailStatus.loading));

    try {
      final article = await _getArticleDetail(id);
      if (isClosed) return;
      emit(
        ArticleDetailState(
          status: ArticleDetailStatus.success,
          article: article,
        ),
      );
    } on Failure catch (failure) {
      if (isClosed) return;
      emit(
        ArticleDetailState(
          status: ArticleDetailStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }
}
