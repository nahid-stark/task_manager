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

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool _getAllProgressTaskListInProgress = false;
  TaskListWrapper _processTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    _getAllProgressTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppbar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllProgressTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(  /// TODO: Make it Operational
            onRefresh: () async {
              _getAllProgressTaskList();
            },
            child: Visibility(
              visible: _processTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const EmptyListWidget(),
              child: ListView.builder(
                itemCount: _processTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    screenTitle: "ProgressTask",
                    taskItem: _processTaskListWrapper.taskList![index],
                    refreshList: (){
                      _getAllProgressTaskList();
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

  Future<void> _getAllProgressTaskList() async {
    _getAllProgressTaskListInProgress = true;
    setState(() {});
    final ResponseObject response =
    await NetworkCaller.getRequest(Urls.progressTaskList);
    if (response.isSuccess) {
      _processTaskListWrapper =
          TaskListWrapper.fromJson(response.responseBody);
      _getAllProgressTaskListInProgress = false;
      setState(() {});
    } else {
      _getAllProgressTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Get Progress task list has been failed!");
      }
    }
  }
}
