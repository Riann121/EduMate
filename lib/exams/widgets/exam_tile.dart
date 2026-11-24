import 'package:flutter/material.dart';
import 'package:edumate/theme/app_colors.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';

class ExamTile extends StatelessWidget {
  final UpcomingExamItem exam;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ExamTile({
    super.key,
    required this.exam,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEFEFEF),
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.examTitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exam.courseName,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (exam.syllabus.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        exam.syllabus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _dateBadge(exam.examDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateBadge(DateTime date) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final target = DateUtils.dateOnly(date);
    final dayDiff = target.difference(today).inDays;

    String label;
    Color badgeColor = Colors.white;
    Color textColor = AppColors.onSurface;

    if (dayDiff == 0) {
      label = 'Today';
      badgeColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
    } else if (dayDiff == 1) {
      label = 'Tomorrow';
      badgeColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else {
      const monthShort = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      label = '${monthShort[target.month - 1]} ${target.day}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD3D3D3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
