import 'package:flutter/material.dart';
import '../widgets/routine_action_button.dart';
import '../widgets/routine_table_cell.dart';
import 'package:edumate/routine/input_validation/possible_class_validation.dart';
import 'package:edumate/routine/input_validation/input_validation.dart';

class GridEditorPage extends StatelessWidget {
  final TextEditingController startTimeCtrl;
  final TextEditingController durationCtrl;
  final TextEditingController numClassesCtrl;
  final TextEditingController numDaysCtrl;

  final Map<String, String> routineData;
  final List<String> weekDays;

  final VoidCallback onNext;
  final VoidCallback onBack;

  const GridEditorPage({
    super.key,
    required this.startTimeCtrl,
    required this.durationCtrl,
    required this.numClassesCtrl,
    required this.numDaysCtrl,
    required this.routineData,
    required this.weekDays,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    int slots = int.tryParse(numClassesCtrl.text) ?? 5;
    int duration = int.tryParse(durationCtrl.text) ?? 60;
    int classes = classPossible(startTimeCtrl.text, duration, slots);

    int days = int.tryParse(numDaysCtrl.text) ?? 5;
    if (days > 7) days = 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Routine",style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Column(
        children: [
          // Table area
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(100),
                    children: [
                      // Header Row
                      TableRow(
                        children: [
                          const RoutineTableCell("Day/Time", isHeader: true),
                          ...List.generate(
                            classes,
                                (c) => RoutineTableCell(
                              calculateTime(c, startTimeCtrl, durationCtrl),
                              isHeader: true,
                            ),
                          ),
                        ],
                      ),
                      // Body Rows
                      ...List.generate(days, (r) {
                        return TableRow(
                          children: [
                            RoutineTableCell(
                              weekDays[r],
                              isHeader: true,
                              isDay: true,
                            ),
                            ...List.generate(classes, (c) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "...",
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                  onChanged: (val) =>
                                  routineData["$r-$c"] = val,
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Post Routine Button
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: RoutineActionButton(
              label: "Post Routine",
              onTap: onNext,
              bg: Colors.black,
              txt: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
