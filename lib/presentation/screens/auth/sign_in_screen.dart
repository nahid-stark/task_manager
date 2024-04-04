import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/sign_in_controller.dart';
import 'package:task_manager/presentation/screens/auth/email_verification_screen.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/password_visibility_control.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController signInController = Get.find<SignInController>();

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
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
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
                      controller: _passwordTEController,
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
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<SignInController>(
                        builder: (signInController) {
                          return Visibility(
                            visible: signInController.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signIn();
                                }
                              },
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const EmailVerificationScreen());
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't Have An Account?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpScreen());
                          },
                          child: const Text("Sign Up"),
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

  Future<void> _signIn() async {
    final bool result = await signInController.signIn(_emailTEController.text.trim(), _passwordTEController.text);
    if (result) {
      if (mounted) {
        Get.off(() => const MainBottomNavScreen());
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, signInController.errorMessage, true);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
