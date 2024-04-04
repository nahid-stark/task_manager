import 'package:flutter/material.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/model/task_item.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  final String screenTitle;

  const TaskCard({
    super.key,
    required this.screenTitle,
    required this.taskItem,
    required this.refreshList,
  });

  final TaskItem taskItem;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress = false;
  Map<String, dynamic> colorsByTaskTitle = {
    "NewTask": Colors.indigoAccent,
    "CompleteTask": Colors.green,
    "ProgressTask": Colors.purpleAccent,
    "CancelledTask": Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    var descriptionAndDate =
        widget.taskItem.description?.split("~") ?? [" ", " "];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskItem.title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              descriptionAndDate[0],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Creation Date: ${descriptionAndDate[1]}",
              style: const TextStyle(
                fontSize: 9,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Container(
                  height: 22,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: colorsByTaskTitle[widget.screenTitle],
                  ),
                  child: Center(
                    child: Text(
                      widget.taskItem.status ?? "",
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
                  child: Visibility(
                    visible: _updateTaskStatusInProgress == false,
                    replacement: const CircularProgressIndicator(),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        _showUpdateStatusDialog(widget.taskItem.sId!);
                      },
                      icon: const Icon(
                        Icons.edit_calendar,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 30,
                  child: Visibility(
                    visible: _deleteTaskInProgress == false,
                    replacement: const CircularProgressIndicator(),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "WARNING !",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              content: const Text(
                                "Are You Want to Delete This Task Forever?",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteTaskById(widget.taskItem.sId!);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
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

  void _showUpdateStatusDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("New"),
                trailing:
                    _isCurrentStatus("New") ? const Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("New")) {
                    return;
                  }
                  _updateTaskById(id, "New");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Completed"),
                trailing: _isCurrentStatus("Completed")
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  if (_isCurrentStatus("Completed")) {
                    return;
                  }
                  _updateTaskById(id, "Completed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Progress"),
                trailing: _isCurrentStatus("Progress")
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  if (_isCurrentStatus("Progress")) {
                    return;
                  }
                  _updateTaskById(id, "Progress");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Cancelled"),
                trailing: _isCurrentStatus("Cancelled")
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  if (_isCurrentStatus("Cancelled")) {
                    return;
                  }
                  _updateTaskById(id, "Cancelled");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isCurrentStatus(String status) {
    return widget.taskItem.status == status;
  }

  Future<void> _updateTaskById(String id, String status) async {
    _updateTaskStatusInProgress = true;
    setState(() {});
    final ResponseObject response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _updateTaskStatusInProgress = false;
    if (response.isSuccess) {
      _updateTaskStatusInProgress = false;
      widget.refreshList();
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Update task status has been failed!");
      }
    }
  }

  Future<void> _deleteTaskById(String id) async {
    _deleteTaskInProgress = true;
    setState(() {});
    final ResponseObject response =
        await NetworkCaller.getRequest(Urls.deleteTask(id));
    _deleteTaskInProgress = false;
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? "Delete task has been failed!");
      }
    }
  }
}
