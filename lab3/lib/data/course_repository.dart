import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course_models.dart';

/// Sursa datelor: fișierul JSON din assets, citit asincron.
class CourseRepository {
  static const _assetPath = 'assets/data/courses.json';

  /// Simulează o întârziere de rețea ca să fie vizibilă starea Loading.
  Future<AppData> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final raw = await rootBundle.loadString(_assetPath);
    return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
