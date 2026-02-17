import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stat_card.dart';

class HomeStatsGrid extends StatelessWidget {
  const HomeStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: HomeStatCard(
                  title: 'Total Classes',
                  value: '6',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: HomeStatCard(
                  title: 'Due This Week',
                  value: '4',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: HomeStatCard(
                  title: 'Total Classes',
                  value: '6',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: HomeStatCard(
                  title: 'Due This Week',
                  value: '4',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
