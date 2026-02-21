import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  int isMade = 0;
  int timeLimit = 0;
  int timeIndex = -1;
  // EduMate Color Palette
  static const Color routineWhite = Colors.white;
  static const Color routineBlack = Color(0xFF111827); // Deep Black/Grey
  static const Color routineGrey = Color(0xFFF3F4F6);  // Light background for inputs
  static const Color routineAccent = Color(0xFF3B82F6); // Blue from the Figma tags

  final TextEditingController _startTimeCtrl = TextEditingController(text: "08:00");
  final TextEditingController _durationCtrl = TextEditingController(text: "60");
  final TextEditingController _numClassesCtrl = TextEditingController(text: "5");
  final TextEditingController _numDaysCtrl = TextEditingController(text: "6");

  Map<String, String> routineData = {};

  final List<String> weekDays = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ];


  String calculateTime(int slotIndex) {
    try {
      List<String> parts = _startTimeCtrl.text.split(':');
      int startHour = int.parse(parts[0]);
      int startMin = parts.length > 1 ? int.parse(parts[1]) : 0;

      int duration = int.parse(_durationCtrl.text);

      int totalMins = (startHour * 60) + startMin + (duration * slotIndex);
      if (totalMins >= 24 * 60) {
        timeLimit = 1;
        timeIndex = slotIndex;
      }
      int finalHour = (totalMins ~/ 60) % 24;
      int finalMin = totalMins % 60;
      String period = finalHour >= 12 ? "PM" : "AM";
      int displayHour = finalHour % 12 == 0 ? 12 : finalHour % 12;
      return "$displayHour:${finalMin.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return "Slot ${slotIndex + 1}";
    }
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: routineWhite),
            onPressed: () {
              if (isMade == 2 || isMade == 0) {
                Navigator.pop(context);
              } else {
                setState(() => isMade--);
              }
            },
          ),
        ),
      body:_buildStep()
    );
  }

//Main Body of the page
  Widget _buildStep() {
    switch (isMade) {
      case 0: return _buildSetupView();
      case 1: return _buildGridEditor();
      case 2: return _buildFinalView();//the final and last page
      default: return _buildSetupView();
    }
  }

  // Setup screen (input form)
  Widget _buildSetupView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // const Text("Welcome back to", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const Text("EduMate", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: routineBlack)),
          const SizedBox(height: 40),
          _inputLabel("Start Time"),
          _inputField(_startTimeCtrl, "e.g. 08:00", Icons.access_time),
          _inputLabel("Duration (Minutes)"),
          _inputField(_durationCtrl, "e.g. 60", Icons.timer_outlined, isNum: true),
          _inputLabel("Total Classes"),
          _inputField(_numClassesCtrl, "e.g. 5", Icons.grid_view, isNum: true),
          _inputLabel("Total Days"),
          _inputField(_numDaysCtrl, "e.g. 6", Icons.calendar_month, isNum: true),
          const SizedBox(height: 30, ),
          _actionButton("Create Routine", () => setState(() => isMade = 1), routineBlack, routineWhite),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  // Routine editor grid
  Widget _buildGridEditor() {
    int classes = int.tryParse(_numClassesCtrl.text) ?? 7;
      if (timeIndex != -1) {
        classes = timeIndex;
      }
    int days = int.tryParse(_numDaysCtrl.text) ?? 5;

    return Column(
      children: [
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
                    TableRow(
                      children: [
                        _tableCell("Day/Time", isHeader: true),
                        ...List.generate(classes, (c) => _tableCell(calculateTime(c), isHeader: true)),
                      ],
                    ),
                    ...List.generate(days, (r) {
                      return TableRow(
                        children: [
                          _tableCell(weekDays[r % 7], isHeader: true, isDay: true),
                          ...List.generate(classes, (c) {
                            return Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: routineGrey, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(border: InputBorder.none, hintText: "..."),
                                onChanged: (val) => routineData["$r-$c"] = val,
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
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: _actionButton(
              "Post Routine",
                  () => setState(() => isMade = 2),
              routineBlack,
              routineWhite
          ),
        ),
      ],
    );
  }

  // Final routine display
  Widget _buildFinalView(){
    int classes = int.tryParse(_numClassesCtrl.text) ?? 7;
    if (timeIndex != -1) {
      classes = timeIndex;
    }
    int days = int.tryParse(_numDaysCtrl.text) ?? 5;
    if(days >= 7) days = 7;


    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(100),
                  border: TableBorder.all(color: Colors.grey.shade200, width: 1, borderRadius: BorderRadius.circular(8)),
                  children: [
                    TableRow(
                      children: [
                        _tableCell("Day", isHeader: true, color: routineGrey),
                        ...List.generate(classes, (c) => _tableCell(calculateTime(c), isHeader: true, color: routineGrey)),
                      ],
                    ),
                    ...List.generate(days, (r) {
                      return TableRow(
                        children: [
                          _tableCell(weekDays[r % 7], isHeader: true),
                          ...List.generate(classes, (c) {
                            String subject = routineData["$r-$c"] ?? "";
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(subject.isEmpty ? "-" : subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  if (subject.isNotEmpty) Container(height: 4, width: 4, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: routineAccent, shape: BoxShape.circle))
                                ],
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
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: _actionButton(
              "Update Routine",
                  () => setState(() => isMade = 0),
              routineWhite,
              routineBlack,
              routineBlack
          ),
        ),
      ],
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

  // Table cell widget used in both editor & final routine view
  Widget _tableCell(String text, {bool isHeader = false, bool isDay = false, Color? color}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w900 : FontWeight.normal,
          fontSize: isDay ? 11 : 12,
          color: isDay ? routineAccent : routineBlack,
        ),
      ),
    );
  }
  // Custom styled button used across all steps
  Widget _actionButton(String label, VoidCallback action, Color bg, Color txt, [Color borderColor = Colors.white]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: txt,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: borderColor, width: 1),
          elevation: 0,
        ),
        onPressed: action,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

}

