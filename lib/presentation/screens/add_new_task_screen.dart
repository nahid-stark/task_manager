import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/profile_bar.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;
  bool _shouldRefreshNewTaskList = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async  {
        Navigator.pop(context, _shouldRefreshNewTaskList);
        return false;
      },
      child: Scaffold(
        appBar: profileAppbar,
        body: BackgroundWidget(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add New Task",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                            ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _titleTEController,
                        decoration: const InputDecoration(
                          hintText: "Title",
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Enter Your Task Title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _descriptionTEController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Enter Your Task Description";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: _addNewTaskInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _addNewTask();
                              }
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "title": _titleTEController.text.trim(),
      "description": "${_descriptionTEController.text.trim()}~${_getDateAndTime()}",
      "status": "New"
    };
    final ResponseObject response = await NetworkCaller.postRequest(Urls.createTask, inputParams);
    _addNewTaskInProgress = false;
    setState(() {});
    if(response.isSuccess) {
      _shouldRefreshNewTaskList = true;
      _titleTEController.clear();
      _descriptionTEController.clear();
      if(mounted) {
        showSnackBarMessage(context, "New Task Has been Added");
      }
    } else {
      if(mounted) {
        showSnackBarMessage(context, response.errorMessage ?? "Add New Task Failed", true);
      }
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

  String _getDateAndTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('hh:mm a').format(now);
    return "${now.day}-${now.month}-${now.year} $formattedTime";
  }
}
