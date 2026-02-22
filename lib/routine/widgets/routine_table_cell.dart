import 'package:flutter/material.dart';

class RoutineTableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isDay;
  final Color? backgroundColor;
  final Color? textColor;

  const RoutineTableCell(
      this.text, {
        super.key,
        this.isHeader = false,
        this.isDay = false,
        this.backgroundColor,
        this.textColor,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 6,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight:
          isHeader ? FontWeight.w800 : FontWeight.normal,
          fontSize: isDay ? 11 : 12,
          color: textColor ??
              (isDay ? Colors.blue : Colors.black),
        ),
      ),
    );
  }
}