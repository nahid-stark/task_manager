import 'package:flutter/material.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/model/set_new_password_data.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/email_otp_holder_temporary.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/password_visibility_control.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _setNewPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Minimum length password 8 character with Latter and number combination",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      keyboardType: TextInputType.text,
                      obscureText:
                          PasswordVisibilityControl.getObscureTextState,
                      decoration: InputDecoration(
                        suffix: PasswordVisibilityControl(
                          onPressed: () {
                            PasswordVisibilityControl.setObscureTextState =
                                !PasswordVisibilityControl.getObscureTextState;
                            setState(() {});
                          },
                        ),
                        hintText: "Password",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your Password";
                        }
                        if (value!.length <= 6) {
                          return "Password Should More Than 6 Letters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      keyboardType: TextInputType.text,
                      obscureText:
                          PasswordVisibilityControl.getObscureTextState,
                      decoration: InputDecoration(
                        suffix: PasswordVisibilityControl(
                          onPressed: () {
                            PasswordVisibilityControl.setObscureTextState =
                                !PasswordVisibilityControl.getObscureTextState;
                            setState(() {});
                          },
                        ),
                        hintText: "Confirm Password",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Confirm Your Password";
                        }
                        if (value!.length <= 6) {
                          return "Password Should More Than 6 Letters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _setNewPasswordInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordTEController.text ==
                                  _confirmPasswordTEController.text) {
                                _setPassword();
                              } else {
                                showSnackBarMessage(
                                    context, "Password Don't Match", true);
                              }
                            }
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have Account?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "Sign in",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setPassword() async {
    _setNewPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> params = {
      "email": EmailAndOtpHolderTemporary.tempEmail,
      "OTP": EmailAndOtpHolderTemporary.tempOtp,
      "password": _confirmPasswordTEController.text,
    };
    ResponseObject response =
        await NetworkCaller.postRequest(Urls.setNewPassword, params);
    _setNewPasswordInProgress = true;
    setState(() {});
    SetNewPasswordData data = SetNewPasswordData.fronJson(response.responseBody);
    if(response.isSuccess) {
      if(data.status == "success") {
        if (mounted) {
          showSnackBarMessage(context,
              "Password Changed Successfully. Please Login!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
                (route) => false,
          );
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context,
              "Something Wrong. Try again!", true);
        }
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Something Wrong!");
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
