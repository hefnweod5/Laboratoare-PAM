import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/overview_cubit.dart';
import '../bloc/overview_state.dart';
import '../core/app_colors.dart';
import '../models/course_models.dart';
import '../widgets/app_image.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/sort_button.dart';
import '../widgets/state_views.dart';
import 'lesson_detail_screen.dart';

/// Pagina de detalii a cursului (courseOverviewPage din JSON).
class CourseOverviewScreen extends StatefulWidget {
  final CourseOverview overview;

  const CourseOverviewScreen({super.key, required this.overview});

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = widget.overview.navigation;
    final icons = widget.overview.uiIcons;
    final cubit = context.read<CourseOverviewCubit>();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: BlocBuilder<CourseOverviewCubit, OverviewState>(
          builder: (context, state) {
            final course = state.course;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 18, 6),
                  child: Row(
                    children: [
                      _BackButton(
                        url: navigation.backIconUrl,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          navigation.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: kInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 26),
                    children: [
                      _CourseHeroView(course: course),
                      const SizedBox(height: 16),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: kInk,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _MetaItem(
                            iconUrl: icons.ratingIconUrl,
                            label: course.rating.toString(),
                            fallback: Icons.star_rounded,
                          ),
                          _MetaItem(
                            iconUrl: icons.durationIconUrl,
                            label: course.duration,
                            fallback: Icons.schedule_rounded,
                          ),
                          _MetaItem(
                            iconUrl: icons.lessonsIconUrl,
                            label: '${course.lessonCount} lessons',
                            fallback: Icons.menu_book_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Tabs(
                        tabs: course.tabs.items,
                        selectedId: state.tabId,
                        onSelected: cubit.setTab,
                      ),
                      const SizedBox(height: 14),
                      if (state.tabId == 'lessons')
                        ..._buildLessons(context, state)
                      else
                        _buildDescription(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _BottomBar(actions: widget.overview.actions),
    );
  }

  List<Widget> _buildLessons(BuildContext context, OverviewState state) {
    final cubit = context.read<CourseOverviewCubit>();

    return [
      TextField(
        controller: _searchController,
        onChanged: cubit.setQuery,
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: 'Caută o lecție...',
          hintStyle: const TextStyle(fontSize: 13, color: kGrey),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: kGrey),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: kGrey),
                onPressed: () {
                  _searchController.clear();
                  cubit.setQuery('');
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
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: FilterChipsBar(
              filters: LessonFilter.values
                  .map((f) => FilterEntry(f.name, f.label))
                  .toList(),
              selectedId: state.filter.name,
              onSelected: (id) => cubit.setFilter(
                LessonFilter.values.firstWhere((f) => f.name == id),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SortMenu<LessonSort>(
            value: state.sort,
            entries: LessonSort.values
                .map((s) => MenuEntry(s, s.label))
                .toList(),
            onSelected: cubit.setSort,
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (state.isEmpty)
        EmptyView(
          message: 'Nicio lecție nu corespunde căutării sau filtrului.',
          onAction: () {
            _searchController.clear();
            cubit.resetFilters();
          },
        )
      else
        ...state.visibleLessons.map(
          (lesson) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LessonTile(
              lesson: lesson,
              isFavorite: state.favoriteLessonIds.contains(lesson.id),
              onFavorite: () => cubit.toggleFavorite(lesson.id),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider<CourseOverviewCubit>.value(
                      value: cubit,
                      child: LessonDetailScreen(lesson: lesson),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    ];
  }

  Widget _buildDescription(BuildContext context, OverviewState state) {
    final text = state.course.description.text.trim();
    if (text.isEmpty) {
      return EmptyView(
        title: 'Fără descriere',
        message: 'Cursul nu are încă o descriere în fișierul JSON.',
        actionLabel: 'Vezi lecțiile',
        onAction: () => context.read<CourseOverviewCubit>().setTab('lessons'),
      );
    }
    return Text(
      text,
      style: const TextStyle(fontSize: 13.5, color: kInkSoft, height: 1.5),
    );
  }
}

class _BackButton extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const _BackButton({required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AppSvg(
            url: url,
            size: 20,
            fallback: Icons.arrow_back_rounded,
          ),
        ),
      ),
    );
  }
}

class _CourseHeroView extends StatelessWidget {
  final Course course;

  const _CourseHeroView({required this.course});

  @override
  Widget build(BuildContext context) {
    final hero = course.hero;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 195,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(url: hero.imageUrl),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hero.label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: kInk,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppSvg(
                  url: hero.playIconUrl,
                  size: 34,
                  fallback: Icons.play_arrow_rounded,
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Row(
                children: [
                  _HeroStat(value: '${hero.videoCount}', label: 'videos'),
                  const SizedBox(width: 16),
                  _HeroStat(value: '${hero.classCount}', label: 'classes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String iconUrl;
  final String label;
  final IconData fallback;

  const _MetaItem({
    required this.iconUrl,
    required this.label,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(url: iconUrl, size: 18, fallback: fallback),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kInkSoft,
          ),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  final List<CourseTab> tabs;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _Tabs({
    required this.tabs,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs.map((tab) {
        final selected = tab.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(tab.id),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? kInk : kGrey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 3,
                  width: 30,
                  decoration: BoxDecoration(
                    color: selected ? kOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final CourseActions actions;

  const _BottomBar({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        12,
        18,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Price',
                style: TextStyle(fontSize: 11, color: kGrey),
              ),
              Text(
                actions.price.label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: kInk,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 46,
            child: FilledButton(
              onPressed: actions.enroll.enabled
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${actions.enroll.label} — te-ai înscris la curs!',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(actions.enroll.label),
            ),
          ),
        ],
      ),
    );
  }
}
