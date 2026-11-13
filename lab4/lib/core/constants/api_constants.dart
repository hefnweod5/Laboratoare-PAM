/// Constantele serviciului Web REST folosit de aplicație.
class ApiConstants {
  const ApiConstants._();

  static const String host = 'dummyjson.com';

  /// Numărul de articole cerute pe pagină.
  static const int pageSize = 10;

  static const Duration timeout = Duration(seconds: 15);
}
