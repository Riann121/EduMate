import 'package:flutter/material.dart';

String calculateTime(int slotIndex, TextEditingController startTimeCtrl, TextEditingController durationCtrl) {
  try {
    List<String> parts = startTimeCtrl.text.split(':');
    int startHour = int.parse(parts[0]);
    int startMin = parts.length > 1 ? int.parse(parts[1]) : 0;
    int duration = int.parse(durationCtrl.text);
    int totalMins = (startHour * 60) + startMin + (duration * slotIndex);
    int finalHour = (totalMins ~/ 60) % 24;
    int finalMin = totalMins % 60;
    String period = finalHour >= 12 ? "PM" : "AM";
    int displayHour = finalHour % 12 == 0 ? 12 : finalHour % 12;
    return "$displayHour:${finalMin.toString().padLeft(2, '0')} $period";
  } catch (e) {
    return "Slot ${slotIndex + 1}";
  }
}
