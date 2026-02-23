import 'package:flutter/material.dart';

import 'pages/setup_page.dart';
import 'pages/grid_editor_page.dart';
import 'pages/final_page.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {

  // ---------------- STEP CONTROL ----------------
  int currentStep = 0;

  void nextStep() => setState(() => currentStep++);
  void prevStep() => setState(() => currentStep--);
  void resetStep() => setState(() => currentStep = 0);

  // ---------------- CONTROLLERS (SHARED) ----------------
  final TextEditingController startTimeCtrl = TextEditingController(text: "08:00");

  final TextEditingController durationCtrl = TextEditingController(text: "60");

  final TextEditingController numClassesCtrl = TextEditingController(text: "5");

  final TextEditingController numDaysCtrl = TextEditingController(text: "6");

  // ---------------- ROUTINE DATA ----------------
  Map<String, String> routineData = {};

  final List<String> weekDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  void dispose() {
    startTimeCtrl.dispose();
    durationCtrl.dispose();
    numClassesCtrl.dispose();
    numDaysCtrl.dispose();
    super.dispose();
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (currentStep) {
      case 0:
        bodyContent = SetupPage(
          startTimeCtrl: startTimeCtrl,
          durationCtrl: durationCtrl,
          numClassesCtrl: numClassesCtrl,
          numDaysCtrl: numDaysCtrl,
          onNext: nextStep,
        );
        break;
      case 1:
        bodyContent = GridEditorPage(
          startTimeCtrl: startTimeCtrl,
          durationCtrl: durationCtrl,
          numClassesCtrl: numClassesCtrl,
          numDaysCtrl: numDaysCtrl,
          routineData: routineData,
          weekDays: weekDays,
          onNext: nextStep,
          onBack: prevStep,
        );
        break;
      case 2:
        bodyContent = FinalPage(
          startTimeCtrl: startTimeCtrl,
          durationCtrl: durationCtrl,
          numClassesCtrl: numClassesCtrl,
          numDaysCtrl: numDaysCtrl,
          routineData: routineData,
          weekDays: weekDays,
          onReset: resetStep,
        );
        break;
      default:
        bodyContent = SetupPage(
          startTimeCtrl: startTimeCtrl,
          durationCtrl: durationCtrl,
          numClassesCtrl: numClassesCtrl,
          numDaysCtrl: numDaysCtrl,
          onNext: nextStep,
        );
    }

    return Scaffold(
      body: bodyContent,
    );
  }
}