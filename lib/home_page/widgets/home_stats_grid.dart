import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stat_card.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: layout.horizontalPadding,
        vertical: 12,
      ),
      child: Column(
        children: [
          _taskExams(layout),
          SizedBox(height: layout.cardSpacing),
          _assignmentReports(layout),
        ],
      ),
    );
  }

  Widget _taskExams(_HomeStatsLayout layout) {
    return SizedBox(
      height: layout.cardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Expanded(
            child: HomeStatCard(
              title: 'Due Tasks',
              value: '7',
            ),
          ),
          SizedBox(width: layout.cardSpacing),
          Expanded(
            child: HomeStatCard(
              title: 'Upcoming Exams',
              value: '2',
            ),
          ),
        ],
      ),
    );
  }

  Widget _assignmentReports(_HomeStatsLayout layout) {
    return SizedBox(
      height: layout.cardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: HomeStatCard(
              title: 'Due Assignments',
              value: '6',
            ),
          ),
          SizedBox(width: layout.cardSpacing),
          Expanded(
            child: HomeStatCard(
              title: 'Due Lab Reports',
              value: '4',
            ),
          ),
        ],
      ),
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
