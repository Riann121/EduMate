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
      decoration: _sectionContainerDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming Exams This Week",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ..._sectionContent(), //spread operator
        ],
      ),
    );
  }


  BoxDecoration _sectionContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }


  //section content - list of upcoming exams or empty state
  List<Widget> _sectionContent() {
    if (_upcomingExams.isEmpty) {
      return [_emptyState()];
    }

    return _upcomingExams.asMap().entries
        .map((entry) {return _examTile(index: entry.key, item: entry.value);})
        .toList(growable: false);
  }

  Widget _emptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'No upcoming exams this week',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  //exam tile for each upcoming exam item in the list
  Widget _examTile({required int index, required UpcomingExamItem item}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: const Color(0xFFEFEFEF),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showExamDetailsDialog(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Expanded(child: _examTileDetails(item)),
                Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _examTileDetails(UpcomingExamItem item) {
    return Column(
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
    );
  }


  //dialog that shows more details about the exam when an exam tile is tapped
  Future<void> _showExamDetailsDialog(int index) async {
    final item = _upcomingExams[index];
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exam Details'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
