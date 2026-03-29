import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/course_item.dart';
import 'package:edumate/courses/course_details_page_template.dart';

Future<void> showAddCustomCourseDialog({
  required BuildContext context,
  required Function(CourseItem, bool isTheory) onAdd,
}) async {
  final courseNameController = TextEditingController();
  final instructorController = TextEditingController();
  final overviewController = TextEditingController();
  bool isTheory = true;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Course'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: courseNameController,
                    decoration: const InputDecoration(labelText: 'Course Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instructorController,
                    decoration: const InputDecoration(
                      labelText: 'Teacher Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: overviewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Course overview',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  RadioGroup<bool>(
                    groupValue: isTheory,
                    onChanged: (value) => setState(() => isTheory = value!),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Text('Course Type: '),
                        Radio<bool>(value: true),
                        Text('Theory'),
                        Radio<bool>(value: false),
                        Text('Lab'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = courseNameController.text.trim();
                  final instructor = instructorController.text.trim();
                  final overview = overviewController.text.trim();
                  if (name.isEmpty || instructor.isEmpty || overview.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                    return;
                  }

                  final page = CourseTemplatePage(
                    courseName: name,
                    instructorName: instructor,
                    overview: overview,
                    assignments: const [],
                    lectures: const [],
                  );

                  onAdd(CourseItem(name, instructor, page), isTheory);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );

  // dispose controllers
  // courseNameController.dispose();
  // instructorController.dispose();
  // overviewController.dispose();
}
