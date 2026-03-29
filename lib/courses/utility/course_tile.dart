import 'package:flutter/material.dart';
import 'package:edumate/theme/app_colors.dart';
import 'course_item.dart';

class CourseTile extends StatelessWidget {
  final CourseItem course;
  final VoidCallback onTap;

  const CourseTile({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Card(
      color: Color(0xFFEFEFEF),
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.teacherName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No. of assignments',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.menu_book_outlined, size: 22, color: Colors.black),
          ],
        ),
      ),
    ),
  );
}
