import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoutine();
  }

  Future<void> _fetchRoutine() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('routines')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        startTimeCtrl.text = data['startTime'] ?? "08:00";
        durationCtrl.text = data['duration'] ?? "60";
        numClassesCtrl.text = data['numClasses'] ?? "5";
        numDaysCtrl.text = data['numDays'] ?? "6";

        if (data['routineData'] != null) {
          routineData = Map<String, String>.from(data['routineData']);
        }

        setState(() {
          currentStep = 2; // FinalPage
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching routine: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveRoutine() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('routines').doc(user.uid).set({
        'userId': user.uid,
        'startTime': startTimeCtrl.text,
        'duration': durationCtrl.text,
        'numClasses': numClassesCtrl.text,
        'numDays': numDaysCtrl.text,
        'routineData': routineData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error saving routine: $e");
    }
  }

  void nextStep() {
    if (currentStep == 1) {
      _saveRoutine();
    }
    setState(() => currentStep++);
  }

  void prevStep() => setState(() => currentStep--);
  void resetStep() => setState(() => currentStep = 0);

  // ---------------- CONTROLLERS (SHARED) ----------------
  final TextEditingController startTimeCtrl =
      TextEditingController(text: "08:00");

  final TextEditingController durationCtrl = TextEditingController(text: "60");

  final TextEditingController numClassesCtrl =
      TextEditingController(text: "5");

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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

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