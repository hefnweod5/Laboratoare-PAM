import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../cubit/overview_cubit.dart';
import '../models/course_list_item.dart';
import '../models/filters.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/meetup_card.dart';
import '../widgets/prompt_card.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import '../widgets/sort_button.dart';
import 'course_overview_page.dart';
import 'course_plan_page.dart';

/// Ecranul principal: designul din Laboratorul 3, datele din REST API.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading) {
              return const LoadingView(message: 'Se încarcă datele de la API...');
            }

            if (state.status == HomeStatus.failure) {
              return ErrorView(
                message: state.errorMessage ?? 'Datele nu au putut fi încărcate.',
                onRetry: context.read<HomeCubit>().load,
              );
            }

            final feed = state.feed;
            final details = state.details;
            if (feed == null || details == null) {
              return EmptyView(
                title: 'Feed indisponibil',
                message: 'Nu există date de afișat momentan.',
                onAction: context.read<HomeCubit>().load,
              );
            }

            final cubit = context.read<HomeCubit>();

            return RefreshIndicator(
              color: kOrange,
              onRefresh: cubit.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                children: [
                  HomeHeaderBar(
                    data: feed.header,
                    onNotificationTap: () => _message(
                      context,
                      feed.header.hasUnread
                          ? 'Ai notificări noi.'
                          : 'Nu ai notificări noi.',
                    ),
                  ),
                  const SizedBox(height: 18),
                  LearnedTodayCard(data: feed.learnedToday),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: feed.myCourses.title,
                    actionLabel: feed.myCourses.actionLabel,
                  ),
                  const SizedBox(height: 12),
                  SearchField(
                    controller: _searchController,
                    hint: 'Caută un curs...',
                    onChanged: cubit.setQuery,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilterChipsBar(
                          filters: CourseFilter.values
                              .map((f) => FilterEntry(f.name, f.label))
                              .toList(),
                          selectedId: state.filterId,
                          onSelected: cubit.setFilter,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SortMenu<CourseSort>(
                        value: state.sort,
                        entries: CourseSort.values
                            .map((s) => MenuEntry(s, s.label))
                            .toList(),
                        onSelected: cubit.setSort,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (state.visibleCourses.isEmpty)
                    EmptyView(
                      onAction: () {
                        _searchController.clear();
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
                          onTap: () => _openCourse(context, course, details),
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  LearningPromptCard(
                    data: feed.learningPrompt,
                    onAction: () => _message(
                      context,
                      'Alege un curs din lista „${feed.myCourses.title}”.',
                    ),
                  ),
                  const SizedBox(height: 18),
                  MeetupCard(data: feed.meetup),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openCourse(
    BuildContext context,
    CourseListItem course,
    dynamic details,
  ) {
    if (course.isLearningPlan) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CoursePlanPage(course: course),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => OverviewCubit(details),
          child: CourseOverviewPage(details: details),
        ),
      ),
    );
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }
}
