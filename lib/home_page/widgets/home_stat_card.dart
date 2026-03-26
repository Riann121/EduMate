import 'package:flutter/material.dart';

class HomeStatCard extends StatefulWidget {
  final String title;
  final String value;

  const HomeStatCard({super.key, required this.title, required this.value});

  @override
  State<HomeStatCard> createState() => _HomeStatCardState();
}

class _HomeStatCardState extends State<HomeStatCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title
            Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            //value
            Text(
              widget.value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
      ),
    );
  }
}
