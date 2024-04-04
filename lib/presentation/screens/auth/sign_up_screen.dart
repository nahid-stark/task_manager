import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/sign_up_controller.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/password_visibility_control.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController signUpController = Get.find<SignUpController>();

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
                      "Join With Us",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your Email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _firstNameTEController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your First Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _lastNameTEController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your Last Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Mobile",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your Mobile No.";
                        }
                        return null;
                      },
                      maxLength: 11,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText:
                          PasswordVisibilityControl.getObscureTextState,
                      controller: _passwordTEController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffix: PasswordVisibilityControl(
                          onPressed: () {
                            PasswordVisibilityControl.setObscureTextState =
                                !PasswordVisibilityControl.getObscureTextState;
                            setState(() {});
                          },
                        ),
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
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<SignUpController>(
                        builder: (signUpController) {
                          return Visibility(
                            visible: signUpController.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signUp();
                                }
                              },
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        }
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have Account?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sign In",
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

  Future<void> _signUp() async {
    final bool result = await signUpController.signIn(_emailTEController.text.trim(), _firstNameTEController.text.trim(), _lastNameTEController.text.trim(), _mobileTEController.text.trim(), _passwordTEController.text);
    if (result) {
      if (mounted) {
        showSnackBarMessage(context,
            "Registration Success. Please Login");
        Get.back();
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            "Registration Failed. Try Again", true);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
