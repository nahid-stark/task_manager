import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/model/user_data.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/password_visibility_control.dart';
import 'package:task_manager/presentation/widgets/profile_bar.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static int counter = 0;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData?.email ?? "";
    _firstNameTEController.text = AuthController.userData?.firstName ?? "";
    _lastNameTEController.text = AuthController.userData?.lastName ?? "";
    _mobileTEController.text = AuthController.userData?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Update Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    imagePickerButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _firstNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _lastNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
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
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      keyboardType: TextInputType.text,
                      obscureText:
                          PasswordVisibilityControl.getObscureTextState,
                      decoration: InputDecoration(
                        hintText: "Password(Optional)",
                        suffix: PasswordVisibilityControl(
                          onPressed: () {
                            PasswordVisibilityControl.setObscureTextState =
                                !PasswordVisibilityControl.getObscureTextState;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _updateProfileInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _updateProfile();
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
    );
  }

  Widget imagePickerButton() {
    return GestureDetector(
      onTap: () {
        pickImageFromGallery();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Text(
                "Photo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                _pickedImage?.name ?? "",
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    UpdateProfileScreen.counter = 0;
    super.dispose();
  }

  Future<void> _updateProfile() async {
    String? photo;
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty) {
      inputParams["password"] = _passwordTEController.text;
    }
    if (_pickedImage != null) {
      List<int> bytes = File(_pickedImage!.path).readAsBytesSync();
      photo = base64Encode(bytes);
      inputParams["photo"] = photo;
    }
    final ResponseObject response =
        await NetworkCaller.postRequest(Urls.profileUpdate, inputParams);
    _updateProfileInProgress = false;
    if (response.isSuccess) {
      if (response.responseBody["status"] == "success") {
        UserData userData = UserData(
          email: _emailTEController.text,
          firstName: _firstNameTEController.text.trim(),
          lastName: _lastNameTEController.text.trim(),
          mobile: _mobileTEController.text.trim(),
          photo: photo,
        );
        await AuthController.saveUserData(userData);
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
          (route) => false,
        );
      }
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Profile Update Failed! Try Again");
      }
    }
  }
}
