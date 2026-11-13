import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/failures.dart';

/// Client HTTP subțire, folosit exclusiv de data sources.
///
/// Face cererea, decodează JSON-ul și traduce excepțiile tehnice în `Failure`.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.https(ApiConstants.host, path, query);

    try {
      final response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(ApiConstants.timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerFailure(
          'Serverul a răspuns cu codul ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const ParseFailure('Formatul răspunsului este neașteptat.');
      }
      return decoded;
    } on Failure {
      rethrow;
    } on SocketException {
      throw const NetworkFailure(
        'Nu există conexiune la internet. Verifică rețeaua.',
      );
    } on TimeoutException {
      throw const NetworkFailure(
        'Serverul nu a răspuns la timp. Încearcă din nou.',
      );
    } on FormatException {
      throw const ParseFailure('Răspunsul primit nu este JSON valid.');
    } on http.ClientException {
      throw const NetworkFailure('Cererea HTTP a eșuat.');
    } catch (error) {
      throw UnknownFailure('Eroare neașteptată: $error');
    }
  }
}
