import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskItem,
  });

  final TaskItem taskItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskItem.title ?? ""),
            Text(taskItem.description ?? ""),
            Text("Date: ${taskItem.createdDate}"),
            Row(
              children: [
                Container(
                  height: 22,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.lightBlue,
                  ),
                  child: Center(
                    child: Text(
                      taskItem.status ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 25,
                  width: 40,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_calendar,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 30,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}