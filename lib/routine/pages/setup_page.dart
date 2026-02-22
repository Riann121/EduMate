import 'package:flutter/material.dart';
import '../widgets/routine_input_field.dart';
import '../widgets/routine_action_button.dart';

class SetupPage extends StatelessWidget {
  final TextEditingController startTimeCtrl;
  final TextEditingController durationCtrl;
  final TextEditingController numClassesCtrl;
  final TextEditingController numDaysCtrl;
  final VoidCallback onNext;

  const SetupPage({
    super.key,
    required this.startTimeCtrl,
    required this.durationCtrl,
    required this.numClassesCtrl,
    required this.numDaysCtrl,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Routine")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "EduMate",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            RoutineInputField(
              label: "Start Time",
              ctrl: startTimeCtrl,
              hint: "08:00",
              icon: Icons.access_time,
            ),

            RoutineInputField(
              label: "Duration (Minutes)",
              ctrl: durationCtrl,
              hint: "60",
              icon: Icons.timer,
              isNum: true,
            ),

            RoutineInputField(
              label: "Total Classes",
              ctrl: numClassesCtrl,
              hint: "5",
              icon: Icons.grid_view,
              isNum: true,
            ),

            RoutineInputField(
              label: "Total Days",
              ctrl: numDaysCtrl,
              hint: "6",
              icon: Icons.calendar_month,
              isNum: true,
            ),

            const SizedBox(height: 30),

            RoutineActionButton(
              label: "Create Routine",
              onTap: onNext,
              bg: Colors.black,
              txt: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}