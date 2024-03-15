import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/screens/update_profile_screen.dart';
import 'package:task_manager/presentation/utils/app_colors.dart';

PreferredSizeWidget get profileAppbar {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: () {
        if (UpdateProfileScreen.counter == 0) {
          Navigator.push(
            TaskManager.navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen(),
            ),
          );
        }
        UpdateProfileScreen.counter = 999;
      },
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          const CircleAvatar(),
          const SizedBox(
            width: 12,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "rabbil@gmail.com",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                TaskManager.navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
