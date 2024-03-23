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

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  TaskListWrapper _cancelledTaskListWrapper = TaskListWrapper();
  bool _getAllCancelledTaskListInProgress = false;

  @override
  void initState() {
    _getAllCancelledTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppbar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllCancelledTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(  /// TODO: Make it Operational
            onRefresh: () async {
              _getAllCancelledTaskList();
            },
            child: Visibility(
              visible: _cancelledTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const EmptyListWidget(),
              child: ListView.builder(
                itemCount: _cancelledTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskItem: _cancelledTaskListWrapper.taskList![index],
                    refreshList: (){
                      _getAllCancelledTaskList();
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

  Future<void> _getAllCancelledTaskList() async {
    _getAllCancelledTaskListInProgress = true;
    setState(() {});
    final ResponseObject response =
    await NetworkCaller.getRequest(Urls.cancelledTaskList);
    if (response.isSuccess) {
      _cancelledTaskListWrapper =
          TaskListWrapper.fromJson(response.responseBody);
      _getAllCancelledTaskListInProgress = false;
      setState(() {});
    } else {
      _getAllCancelledTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Get Cancelled task list has been failed!");
      }
    }
  }
}
