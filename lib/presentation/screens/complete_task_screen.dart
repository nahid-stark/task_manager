import 'package:flutter/material.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/model/task_list_wrapper.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager/presentation/widgets/profile_bar.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _getAllCompletedTaskListInProgress = false;
  TaskListWrapper _completeTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    _getAllCompletedTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppbar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllCompletedTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(  /// TODO: Make it Operational
            onRefresh: () async {
              _getAllCompletedTaskList();
            },
            child: Visibility(
              visible: _completeTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const EmptyListWidget(),
              child: ListView.builder(
                itemCount: _completeTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    screenTitle: "CompleteTask",
                    taskItem: _completeTaskListWrapper.taskList![index],
                    refreshList: (){
                      _getAllCompletedTaskList();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getAllCompletedTaskList() async {
    _getAllCompletedTaskListInProgress = true;
    setState(() {});
    final ResponseObject response =
        await NetworkCaller.getRequest(Urls.completedTaskList);
    if (response.isSuccess) {
      _completeTaskListWrapper =
          TaskListWrapper.fromJson(response.responseBody);
      _getAllCompletedTaskListInProgress = false;
      setState(() {});
    } else {
      _getAllCompletedTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Get Complete task list has been failed!");
      }
    }
  }
}
