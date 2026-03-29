import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/lecture_item.dart';

void showLectureDetails({
  required BuildContext context,
  required LectureItem lecture,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lecture title
            Text(
              lecture.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lecture date
            Text("Date: ${formatDate(lecture.date)}"),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DOING BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Due"),
                ),

                // FINISHED BUTTON
                ElevatedButton(
                  onPressed: () {
                    onDelete(); // remove lecture
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Complete"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
