import 'package:flutter/material.dart';

class PasswordVisibilityControl extends StatelessWidget {
  static bool obscureTextState = true;
  final VoidCallback onPressed;

  const PasswordVisibilityControl({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
        icon: Icon(
          obscureTextState
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 20,
        ),
      ),
    );
  }
  static bool get getObscureTextState => obscureTextState;
  static set setObscureTextState(bool value) {
    obscureTextState = value;
  }
}
