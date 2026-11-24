import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stat_card.dart';
import 'package:edumate/services/local_storage_service.dart';

class HomeStatsGrid extends StatelessWidget {
  const HomeStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _layoutConfig(constraints.maxWidth);
        return _gridContent(layout);
      },
    );
  }

  _HomeStatsLayout _layoutConfig(double maxWidth) {
    final isNarrow = maxWidth < 380;
    return _HomeStatsLayout(
      horizontalPadding: isNarrow ? 8.0 : 12.0,
      cardSpacing: isNarrow ? 8.0 : 12.0,
      cardHeight: 113.0,
    );
  }

  Widget _gridContent(_HomeStatsLayout layout) {
    final storage = LocalStorageService();

    return AnimatedBuilder(
      animation: Listenable.merge([
        storage.tasksListenable,
        storage.assignmentsListenable,
        storage.coursesListenable,
        storage.examsListenable,
      ]),
      builder: (context, _) {
        final dueTasks =
            storage.getAllTasks().where((t) => !t.isCompleted).length;
        final dueAssignments = storage.getAllAssignments().length;
        final totalCourses = storage.getAllCourses().length;
        final upcomingExams = storage.getUpcomingExamsThisWeek().length;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
            vertical: 12,
          ),
          child: Column(
            children: [
              SizedBox(
                height: layout.cardHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HomeStatCard(
                        title: 'Due Tasks',
                        value: '$dueTasks',
                      ),
                    ),
                    SizedBox(width: layout.cardSpacing),
                    Expanded(
                      child: HomeStatCard(
                        title: 'Upcoming Exams',
                        value: '$upcomingExams',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: layout.cardSpacing),
              SizedBox(
                height: layout.cardHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HomeStatCard(
                        title: 'Due Assignments',
                        value: '$dueAssignments',
                      ),
                    ),
                    SizedBox(width: layout.cardSpacing),
                    Expanded(
                      child: HomeStatCard(
                        title: 'No. of Courses',
                        value: '$totalCourses',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeStatsLayout {
  const _HomeStatsLayout({
    required this.horizontalPadding,
    required this.cardSpacing,
    required this.cardHeight,
  });

  final double horizontalPadding;
  final double cardSpacing;
  final double cardHeight;
}
