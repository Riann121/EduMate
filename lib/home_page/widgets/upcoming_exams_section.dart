import 'package:edumate/home_page/models/upcoming_exam_item.dart';
import 'package:flutter/material.dart';

class UpcomingExamsSection extends StatefulWidget {
  const UpcomingExamsSection({super.key});

  @override
  State<UpcomingExamsSection> createState() => _UpcomingExamsSectionState();
}

class _UpcomingExamsSectionState extends State<UpcomingExamsSection> {
  late final List<UpcomingExamItem> _upcomingExams;

  @override
  void initState() {
    super.initState();
    _upcomingExams = buildDummyUpcomingExamItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context),
          const SizedBox(height: 14),
          ..._sectionContent(),
        ],
      ),
    );
  }

  BoxDecoration _sectionBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }

  Widget _sectionTitle(BuildContext context) {
    return Text(
      "Upcoming Exams This Week",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  List<Widget> _sectionContent() {
    if (_upcomingExams.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'No upcoming exams this week',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ];
    }

    return _upcomingExams
        .asMap()
        .entries
        .map((entry) {
          return _examTile(index: entry.key, item: entry.value);
        })
        .toList(growable: false);
  }

  Widget _examTile({required int index, required UpcomingExamItem item}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showExamDetailsDialog(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.examTitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.courseName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExamDetailsDialog(int index) async {
    final item = _upcomingExams[index];
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exam Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailLine(label: 'Exam Title', value: item.examTitle),
              const SizedBox(height: 10),
              _detailLine(label: 'Course Name', value: item.courseName),
              const SizedBox(height: 10),
              _detailLine(label: 'Syllabus', value: item.syllabus),
            ],
          ),
        );
      },
    );
  }

  Widget _detailLine({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
