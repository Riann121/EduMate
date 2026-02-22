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
      cardHeight: isNarrow ? 100.0 : 108.0,
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
          _statsRow(
            layout: layout,
            leftTitle: 'Due Tasks',
            leftValue: '5',
            rightTitle: 'Upcoming Exams',
            rightValue: '2',
          ),
          SizedBox(height: layout.cardSpacing),
          _statsRow(
            layout: layout,
            leftTitle: 'Due Assignments',
            leftValue: '6',
            rightTitle: 'Due Lab Reports',
            rightValue: '4',
          ),
        ],
      ),
    );
  }

  Widget _statsRow({
    required _HomeStatsLayout layout,
    required String leftTitle,
    required String leftValue,
    required String rightTitle,
    required String rightValue,
  }) {
    return SizedBox(
      height: layout.cardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _statCard(title: leftTitle, value: leftValue),
          ),
          SizedBox(width: layout.cardSpacing),
          Expanded(
            child: _statCard(title: rightTitle, value: rightValue),
          ),
        ],
      ),
    );
  }

  Widget _statCard({required String title, required String value}) {
    return HomeStatCard(title: title, value: value);
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
