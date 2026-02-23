import 'package:flutter/material.dart';
import '../widgets/routine_action_button.dart';
import '../widgets/routine_table_cell.dart';
import 'package:edumate/routine/input_validation/possible_class_validation.dart';
import 'package:edumate/routine/input_validation/input_validation.dart';
class FinalPage extends StatelessWidget {
  final TextEditingController startTimeCtrl;
  final TextEditingController durationCtrl;
  final TextEditingController numClassesCtrl;
  final TextEditingController numDaysCtrl;

  final Map<String, String> routineData;
  final List<String> weekDays;

  final VoidCallback onReset;

  const FinalPage({
    super.key,
    required this.startTimeCtrl,
    required this.durationCtrl,
    required this.numClassesCtrl,
    required this.numDaysCtrl,
    required this.routineData,
    required this.weekDays,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    int slots = int.tryParse(numClassesCtrl.text) ?? 5;
    int duration = int.tryParse(durationCtrl.text) ?? 60;
    int classes = classPossible(startTimeCtrl.text, duration, slots);

    int days = int.tryParse(numDaysCtrl.text) ?? 5;
    if (days > 7) days = 7;

    return Scaffold(
      appBar: AppBar(title: const Text("Routine", style: TextStyle(fontWeight: FontWeight.w900),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(100),
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  TableRow(children: [
                    const RoutineTableCell("Day", isHeader: true),
                    ...List.generate(
                      classes,
                          (c) => RoutineTableCell(
                        calculateTime(c, startTimeCtrl, durationCtrl),
                        isHeader: true,
                      ),
                    ),
                  ]),
                  ...List.generate(days, (r) {
                    return TableRow(children: [
                      RoutineTableCell(
                        weekDays[r],
                        isHeader: true,
                      ),
                      ...List.generate(classes, (c) {
                        String subject =
                            routineData["$r-$c"] ?? "-";
                        return RoutineTableCell(subject);
                      })
                    ]);
                  })
                ],
              ),
            ),
          ),
          RoutineActionButton(
            label: "Update Routine",
            onTap: onReset,
            bg: Colors.white,
            txt: Colors.black,
            border: Colors.black,
          )
        ],
      ),
    );
  }
}