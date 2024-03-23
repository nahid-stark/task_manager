import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/model/otp_verification_data.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/email_otp_holder_temporary.dart';
import 'package:task_manager/presentation/screens/auth/set_password_screen.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/utils/app_colors.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinTEController = TextEditingController();
  bool _otpVerificationInProgress = false;

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
                      "PIN Verification",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "A 6 digits verification code will be sent to your email address",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      controller: _pinTEController,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        inactiveColor: AppColors.themeColor,
                        selectedFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onCompleted: (v) {},
                      onChanged: (value) {},
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _otpVerificationInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _verifyOtp();
                          },
                          child: const Text(
                            "Verify",
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

  Future<void> _verifyOtp() async {
    _otpVerificationInProgress = true;
    setState(() {});
    final ResponseObject response = await NetworkCaller.getRequest(Urls.otpOfPasswordRecoveryProcess(EmailAndOtpHolderTemporary.tempEmail!, _pinTEController.text.trim()));
    _otpVerificationInProgress = false;
    setState(() {});
    if(response.isSuccess) {
      OtpVerificationData data = OtpVerificationData.fronJson(response.responseBody);
      if(data.status == "success") {
        EmailAndOtpHolderTemporary.tempOtp = _pinTEController.text.trim();
        if(mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SetPasswordScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context,
              "Wrong OTP!", true);
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
    //_pinTEController.dispose();
    super.dispose();
  }
}
