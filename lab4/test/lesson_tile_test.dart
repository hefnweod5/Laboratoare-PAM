import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_lucian_varianta4/features/learning/domain/entities/course_details.dart';
import 'package:lab4_lucian_varianta4/features/learning/presentation/widgets/lesson_tile.dart';

Lesson _lesson({
  String title = 'Introduction to React',
  bool completed = false,
  bool locked = false,
}) {
  return Lesson(
    id: 'lesson-1',
    title: title,
    duration: '04:28',
    durationSeconds: 268,
    completed: completed,
    locked: locked,
    playIconUrl: '',
    arrowIconUrl: '',
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  group('LessonTile', () {
    testWidgets('afișează titlul și durata lecției', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LessonTile(
            lesson: _lesson(),
            isFavorite: false,
            onTap: () {},
            onFavorite: () {},
          ),
        ),
      );

      expect(find.text('Introduction to React'), findsOneWidget);
      expect(find.text('04:28'), findsOneWidget);
      expect(find.text('Finalizată'), findsNothing);
    });

    testWidgets('marchează lecția finalizată', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LessonTile(
            lesson: _lesson(completed: true),
            isFavorite: false,
            onTap: () {},
            onFavorite: () {},
          ),
        ),
      );

      expect(find.text('Finalizată'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('lecția blocată afișează eticheta și nu răspunde la tap',
        (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        _wrap(
          LessonTile(
            lesson: _lesson(locked: true),
            isFavorite: false,
            onTap: () => taps++,
            onFavorite: () {},
          ),
        ),
      );

      expect(find.text('Blocată'), findsOneWidget);

      await tester.tap(find.byType(LessonTile));
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('lecția deblocată apelează callback-ul la tap', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        _wrap(
          LessonTile(
            lesson: _lesson(),
            isFavorite: false,
            onTap: () => taps++,
            onFavorite: () {},
          ),
        ),
      );

      await tester.tap(find.byType(LessonTile));
      await tester.pump();

      expect(taps, 1);
    });
  });
}
