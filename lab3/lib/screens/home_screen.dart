import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/courses_cubit.dart';
import '../bloc/courses_state.dart';
import '../bloc/overview_cubit.dart';
import '../core/app_colors.dart';
import '../models/course_models.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/meetup_card.dart';
import '../widgets/prompt_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sort_button.dart';
import '../widgets/state_views.dart';
import 'course_overview_screen.dart';
import 'course_plan_screen.dart';

/// Ecranul principal: dashboard + lista de cursuri cu căutare/filtrare/sortare.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CoursesCubit, CoursesState>(
          builder: (context, state) {
            return switch (state) {
              CoursesLoading() => const LoadingView(),
              CoursesError(:final message) => ErrorView(
                  message: message,
                  onRetry: () => context.read<CoursesCubit>().load(),
                ),
              final CoursesLoaded loaded => _LoadedBody(
                  state: loaded,
                  searchController: _searchController,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final CoursesLoaded state;
  final TextEditingController searchController;

  const _LoadedBody({required this.state, required this.searchController});

  @override
  Widget build(BuildContext context) {
    final home = state.data.home;
    final cubit = context.read<CoursesCubit>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      children: [
        HomeHeaderBar(data: home.header),
        const SizedBox(height: 18),
        LearnedTodayCard(data: home.learnedToday),
        const SizedBox(height: 22),
        SectionHeader(
          title: home.myCourses.title,
          actionLabel: home.myCourses.actionLabel,
        ),
        const SizedBox(height: 12),
        _SearchField(
          controller: searchController,
          onChanged: cubit.setQuery,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FilterChipsBar(
                filters: kCourseFilters
                    .map((f) => FilterEntry(f.id, f.label))
                    .toList(),
                selectedId: state.filterId,
                onSelected: cubit.setFilter,
              ),
            ),
            const SizedBox(width: 8),
            SortMenu<CourseSort>(
              value: state.sort,
              entries: CourseSort.values
                  .map((sort) => MenuEntry(sort, sort.label))
                  .toList(),
              onSelected: cubit.setSort,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state is CoursesEmpty)
          EmptyView(
            onAction: () {
              searchController.clear();
              cubit.resetFilters();
            },
          )
        else
          ...state.visibleCourses.map(
            (course) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CourseCard(
                course: course,
                isFavorite: state.favoriteIds.contains(course.id),
                onFavorite: () => cubit.toggleFavorite(course.id),
                onTap: () => _openCourse(context, course),
              ),
            ),
          ),
        const SizedBox(height: 18),
        LearningPromptCard(
          data: home.learningPrompt,
          onAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Alege un curs din lista "${home.myCourses.title}".',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        MeetupCard(data: home.meetup),
      ],
    );
  }

  void _openCourse(BuildContext context, CourseSummary course) {
    if (course.isLearningPlan) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CoursePlanScreen(course: course),
        ),
      );
      return;
    }

    final overview = state.data.overview;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<CourseOverviewCubit>(
          create: (_) => CourseOverviewCubit(overview.course),
          child: CourseOverviewScreen(overview: overview),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        hintText: 'Caută un curs...',
        hintStyle: const TextStyle(fontSize: 13, color: kGrey),
        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: kGrey),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: kGrey),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            );
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
