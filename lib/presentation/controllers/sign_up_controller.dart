import 'package:get/get.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';

class SignUpController extends GetxController{
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage ?? "Sign Up Failed! Try Again";

  Future<bool> signIn(String email, String firstName, String lastName,
      String mobile, String password) async {
    _inProgress = true;
    bool isSuccess = false;
    update();
    Map<String, dynamic> inputParams = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };
    final ResponseObject response =
    await NetworkCaller.postRequest(Urls.registration, inputParams);
    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}