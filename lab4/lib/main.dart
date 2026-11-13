import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'features/feed/data/datasources/article_remote_data_source.dart';
import 'features/feed/data/repositories/article_repository_impl.dart';

void main() {
  final apiClient = ApiClient();
  final remoteDataSource = ArticleRemoteDataSourceImpl(apiClient);
  final repository = ArticleRepositoryImpl(remoteDataSource);

  runApp(App(repository: repository));
}
