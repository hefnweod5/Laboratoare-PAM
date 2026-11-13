import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_lucian_varianta4/models/course_models.dart';

void main() {
  test('modelele parsează corect courses.json', () {
    final raw = File('assets/data/courses.json').readAsStringSync();
    final data = AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    expect(data.home.header.greeting, 'Hi, Kristin');
    expect(data.home.learnedToday.progress, closeTo(0.7667, 0.0001));
    expect(data.home.learningPlan.items, hasLength(2));
    expect(data.home.meetup.title, 'Meetup');

    final course = data.overview.course;
    expect(course.title, 'React Front To back');
    expect(course.lessonCount, 7);
    expect(course.lessons, hasLength(4));
    expect(course.lessons.last.locked, isTrue);
    expect(data.overview.actions.price.label, 'Free');
    expect(data.overview.actions.enroll.enabled, isTrue);

    final summaries = buildCourseSummaries(data);
    expect(summaries, hasLength(3));
    expect(summaries.first.category, CourseCategory.development);
    expect(summaries[1].category, CourseCategory.design);
  });
}
