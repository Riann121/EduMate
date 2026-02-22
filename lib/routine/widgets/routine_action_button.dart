import 'package:flutter/material.dart';

class RoutineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color bg;
  final Color txt;
  final Color border;

  const RoutineActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.bg,
    required this.txt,
    this.border = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: txt,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: border, width: 1),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}