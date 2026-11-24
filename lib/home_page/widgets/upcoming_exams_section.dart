import 'package:flutter/material.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';
import 'package:edumate/services/local_storage_service.dart';

class UpcomingExamsSection extends StatelessWidget {
  const UpcomingExamsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = LocalStorageService();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionContainerDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Exams This Week",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  Navigator.pushNamed(context, '/exams');
                },
                tooltip: 'View All Exams',
              ),
            ],
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: storage.examsListenable,
            builder: (context, box, child) {
              final upcomingExams = storage.getUpcomingExamsThisWeek();

              if (upcomingExams.isEmpty) {
                return _emptyState();
              }

              return Column(
                children: upcomingExams.asMap().entries.map((entry) {
                  return _examTile(
                    context: context,
                    item: entry.value,
                  );
                }).toList(),
              );
            },
          ),
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

  Widget _emptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'No upcoming exams this week',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _examTile({
    required BuildContext context,
    required UpcomingExamItem item,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: const Color(0xFFEFEFEF),
        elevation: 0.5,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showExamDetailsDialog(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Expanded(child: _examTileDetails(context, item)),
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

  Widget _examTileDetails(BuildContext context, UpcomingExamItem item) {
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

  Future<void> _showExamDetailsDialog(
    BuildContext context,
    UpcomingExamItem item,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exam Details'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailLine(
                context: dialogContext,
                label: 'Exam Title',
                value: item.examTitle,
              ),
              const SizedBox(height: 10),
              _detailLine(
                context: dialogContext,
                label: 'Course Name',
                value: item.courseName,
              ),
              const SizedBox(height: 10),
              _detailLine(
                context: dialogContext,
                label: 'Syllabus',
                value: item.syllabus.isEmpty ? 'No syllabus specified' : item.syllabus,
              ),
              const SizedBox(height: 10),
              _detailLine(
                context: dialogContext,
                label: 'Date',
                value:
                    '${item.examDate.day}/${item.examDate.month}/${item.examDate.year}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailLine({
    required BuildContext context,
    required String label,
    required String value,
  }) {
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
