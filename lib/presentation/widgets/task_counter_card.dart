import 'package:flutter/material.dart';

class TaskCounterCard extends StatelessWidget {
  final int amount;
  final String title;

  const TaskCounterCard({
    super.key,
    required this.amount,
    required this.title,
  });

  static Map<String, dynamic> colorsByTaskTitle = {
    "New": Colors.indigo.shade200,
    "Completed": Colors.green.shade200,
    "Progress": Colors.purple.shade200,
    "Cancelled": Colors.red.shade200,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorsByTaskTitle[title],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            Text(
              "$amount",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}