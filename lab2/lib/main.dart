// Laborator 2 - Varianta 4: Hi, Kristin / React Front To Back
// Autor: Enachi Lucian
// Ecrane: "Home" (Hi, Kristin) si "Course Overview" (React Front To back)
import 'package:flutter/material.dart';

void main() => runApp(const LearningApp());

const Color kBlue = Color(0xFF4361EE);
const Color kOrange = Color(0xFFF47B2A);
const Color kLavender = Color(0xFFEDE3FA);
const Color kLightBlue = Color(0xFFD6EBFA);
const Color kBackground = Color(0xFFF8F9FF);

class LearningApp extends StatelessWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: kBlue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

// ----------------------------------------------------------------------------
// Ecranul 1: Home - Hi, Kristin
// ----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header albastru
            Container(
              color: kBlue,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, Kristin',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Let's start learning",
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: kBlue, size: 32),
                  ),
                ],
              ),
            ),

            // Card progres "Learned today"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Learned today',
                                style: TextStyle(color: Colors.grey)),
                            Text('My courses',
                                style: TextStyle(
                                    color: kBlue,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const [
                            Text('46min',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Text('/ 60min',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(
                            value: 46 / 60,
                            minHeight: 6,
                            color: kOrange,
                            backgroundColor: Color(0xFFEFEFF5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Banner "What do you want to learn today?"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kLightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What do you want to learn today?',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CourseOverviewScreen()),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Learning Plan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Learning Plan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _PlanItem(
                      title: 'Packaging Design', done: 40, total: 48),
                  _PlanItem(title: 'Product Design', done: 6, total: 24),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Banner Meetup
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kLavender,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Meetup',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B1B7A))),
                    SizedBox(height: 4),
                    Text('Off-line exchange of learning experience',
                        style: TextStyle(color: Color(0xFF3B1B7A))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanItem extends StatelessWidget {
  final String title;
  final int done;
  final int total;

  const _PlanItem({required this.title, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              value: done / total,
              strokeWidth: 3,
              color: kBlue,
              backgroundColor: const Color(0xFFEFEFF5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text('$done/$total',
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Ecranul 2: Course Overview - React Front To back
// ----------------------------------------------------------------------------
class CourseOverviewScreen extends StatelessWidget {
  const CourseOverviewScreen({super.key});

  static const _lessons = [
    _Lesson(title: 'Introduction to React', duration: '04:28 min', playing: true),
    _Lesson(title: 'Understanding React', duration: '06:12 min'),
    _Lesson(title: 'Create first React project', duration: '43:58 min'),
    _Lesson(title: 'Build React', duration: '26:18 min'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Course Overview',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _VideoHeader(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('React Front To back',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, color: kOrange, size: 16),
                          SizedBox(width: 4),
                          Text('4.9',
                              style: TextStyle(
                                  color: kOrange,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text('6h 30min  ·  7 lessons',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Tab-uri Lessons / Description
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: kOrange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: kOrange,
                    tabs: [
                      Tab(text: 'Lessons'),
                      Tab(text: 'Description'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(20),
                          children: _lessons
                              .map((l) => _LessonTile(lesson: l))
                              .toList(),
                        ),
                        const SingleChildScrollView(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Învață React de la zero până la un proiect complet: '
                            'componente, state, props și construirea unei aplicații reale.',
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bara de jos: Free + Enroll Now
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: kOrange,
                  side: const BorderSide(color: Color(0xFFEFEFF5)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                onPressed: () {},
                child: const Text('Free',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Te-ai înscris la curs!')),
                    );
                  },
                  child: const Text('Enroll Now',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF8E7CE8), Color(0xFF6B5BD6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 14,
            child: Text('SPOKEN ENGLISH',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: kOrange, size: 40),
          ),
          Positioned(
            bottom: 12,
            child: Row(
              children: const [
                _InfoChip(icon: Icons.play_circle_outline, label: '75 Videos'),
                SizedBox(width: 8),
                _InfoChip(icon: Icons.class_outlined, label: '35 Class'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: kBlue),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final _Lesson lesson;

  const _LessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                lesson.playing ? kOrange : const Color(0xFFFFF3E8),
            child: Icon(Icons.play_arrow_rounded,
                color: lesson.playing ? Colors.white : kOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(lesson.duration,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: kOrange),
        ],
      ),
    );
  }
}

class _Lesson {
  final String title;
  final String duration;
  final bool playing;

  const _Lesson({required this.title, required this.duration, this.playing = false});
}
