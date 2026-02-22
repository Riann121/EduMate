import 'package:flutter/material.dart';

class RoutineInputField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool isNum;

  const RoutineInputField({
    super.key,
    required this.label,
    required this.ctrl,
    required this.hint,
    required this.icon,
    this.isNum = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: ctrl,
              keyboardType:
              isNum ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}