import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/view/set_password/view/set_password.dart';
import 'package:helpero/feature/auth/view/sign_in_screen.dart';
import 'package:helpero/feature/auth/widget/account_create_success_dialog.dart';
import 'package:helpero/feature/widget/auth_footer.dart';
import 'package:helpero/main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../base_widget/show_custom_snakbar_widget.dart';
import '../../navigation/bottom_navigation_bar_screen.dart';
import '../../widget/orDevider.dart';
import '../../widget/otp_input_field.dart';
import '../controllers/auth_controller.dart';

class OtpVerificationDialog extends StatefulWidget {
  final String token;
  final String phoneNumber;
  final String userId;
  final bool isFromForgotPassword;
  const OtpVerificationDialog({
    super.key,
    required this.phoneNumber,
    required this.userId,
    this.isFromForgotPassword = false,
    required this.token,
  });

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
      return;
    }

    if (index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    }

    bool allFilled = otpControllers.every((c) => c.text.isNotEmpty);
    if (allFilled) {
      FocusScope.of(context).unfocus();
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final authController = context.read<AuthController>();
    if (_isVerifying || authController.isLoading) return;

    final otp = otpControllers.map((c) => c.text).join();
    if (otp.isEmpty || otp.length < 4) {
      showCustomSnackBar("Please enter a valid OTP", context);
      return;
    }

    setState(() => _isVerifying = true);
    _animationController.forward();

    final response = await authController.verifyOtp(
      widget.userId,
      otp,
      widget.token,
      isFromForgetPassword: widget.isFromForgotPassword,
    );

    setState(() => _isVerifying = false);

    if (response.isSuccess) {
      for (var controller in otpControllers) {
        controller.clear();
      }

      // if (!widget.isFromForgotPassword) {
      //   showCustomSnackBar("Login Successfully!", Get.context!, isError: false);
      // }
      Navigator.of(Get.context!).pop();
      widget.isFromForgotPassword
          ? Navigator.of(Get.context!).push(
              MaterialPageRoute(
                builder: (context) => SetPassword(
                  phoneNumber: widget.phoneNumber,
                  userId: widget.userId,
                  isForgetPassword: widget.isFromForgotPassword,
                ),
              ),
              // (route) => false,
            )
          : Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BottomNavigationBarScreen(),
              ),
              (route) => false,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter OTP",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "A verification code has been\nsent to +91 ${widget.phoneNumber}",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => OtpInputField(
                controller: otpControllers[index],
                autoFocus: index == 0,
                onChanged: (value) => _onOtpChanged(index, value),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Consumer<AuthController>(
            builder: (context, authController, _) {
              return SizedBox(
                width: 100.w,
                child: OutlinedButton(
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          await _verifyOtp();
                        },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: authController.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Verify",
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't receive the code? ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Resend (30s)",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.0.h),
          widget.isFromForgotPassword
              ? SizedBox()
              : Column(
                  children: [
                    Ordevider(),
                    SizedBox(height: 0.0.h),
                    GestureDetector(
                      onTap: () async {
                        final authController = context.read<AuthController>();
                        final isEligible = await authController
                            .checkLoginWithPassEligibility(widget.phoneNumber);

                        if (isEligible) {
                          Navigator.of(Get.context!).push(
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(
                                isFromOtpVerification: true,
                                phoneNo: widget.phoneNumber,
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(Get.context!).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => SetPassword(
                                phoneNumber: widget.phoneNumber,
                                isForgetPassword: false,
                              ),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        "Login With Password",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
