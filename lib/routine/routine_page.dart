import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  int isMade = 0;

  // EduMate Color Palette
  static const Color routineWhite = Colors.white;
  static const Color routineBlack = Color(0xFF111827); // Deep Black/Grey
  static const Color routineGrey = Color(0xFFF3F4F6);  // Light background for inputs
  static const Color routineAccent = Color(0xFF3B82F6); // Blue from the Figma tags

  final List<String> weekDays = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ];

  //-------------BUILD---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: routineBlack,
          elevation: 0,
          title: Text(
            'Routine',
            style: const TextStyle(fontWeight: FontWeight.w900, color: routineWhite, fontSize: 22),
          ),
          centerTitle: true,
          leading: isMade > 0 ? IconButton(
            icon: const Icon(Icons.arrow_back, color: routineBlack),
            onPressed: () {
              if (isMade == 2) {
                Navigator.pop(context);
              } else {
                setState(() => isMade--);
              }
            },
          ) : null,
        ),
    );
  }

  // Label text used above input fields
  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(label, style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
    );
  }

  // Custom input field used for all form inputs
  Widget _inputField(TextEditingController ctrl, String hint, IconData icon, {bool isNum = false}) {
    return Container(
      decoration: BoxDecoration(color: routineGrey, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: ctrl,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}