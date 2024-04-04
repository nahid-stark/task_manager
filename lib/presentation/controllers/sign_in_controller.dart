import 'package:get/get.dart';
import 'package:task_manager/data/model/login_response.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';

class SignInController extends GetxController{
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage ?? "Login Failed! Try Again";

  Future<bool> signIn(String email, String password) async {
    _inProgress = true;
    bool isSuccess = false;
    update();
    Map<String, dynamic> inputParams = {
      "email": email,
      "password": password,
    };
    final ResponseObject response =
    await NetworkCaller.postRequest(Urls.login, inputParams, fromSignIn: true);
    if (response.isSuccess) {
      LoginResponse loginResponse =
      LoginResponse.fromJson(response.responseBody);
      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}