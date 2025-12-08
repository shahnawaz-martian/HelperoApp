import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/widget/custom_textfield.dart';
import 'package:helpero/feature/widget/password_field.dart';
import 'package:helpero/feature/widget/primary_button.dart';
import 'package:helpero/main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/response_model.dart';
import '../../../helper/velidate_check.dart';

class SignInScreen extends StatefulWidget {
  final bool isFromOtpVerification;
  final String? phoneNo;
  const SignInScreen({
    super.key,
    this.isFromOtpVerification = false,
    this.phoneNo,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    if (widget.isFromOtpVerification && widget.phoneNo!.isNotEmpty) {
      phoneController.text = widget.phoneNo!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );

      if (authController.firstTimeConnectionCheck) {
        bool isConnected =
            await Connectivity().checkConnectivity() != ConnectivityResult.none;

        if (!isConnected) {
          showCustomSnackBar(
            "Check internet connection",
            Get.context!,
            isError: true,
          );
        }

        authController.setFirstTimeConnectionCheck(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(2.h),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40.w,
                  height: 17.h,
                ),
              ),
              SizedBox(height: 3.h),
              Consumer<AuthController>(
                builder: (context, authController, child) {
                  return Form(
                    key: signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome Back",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 0.5.h),
                        widget.isFromOtpVerification
                            ? Text(
                                "Log in to your account using\nMobile No and Password",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      letterSpacing: 1.2,
                                    ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                "Log in to your account using\nMobile No and OTP",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      letterSpacing: 1.2,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                        SizedBox(height: 2.h),
                        // SocialLoginButton(
                        //   text: "Login with Apple",
                        //   logo: 'assets/images/apple_logo.png',
                        //   onTap: () {},
                        // ),
                        // SizedBox(height: 1.h),
                        // SocialLoginButton(
                        //   text: "Login with Google",
                        //   logo: 'assets/images/google_logo.png',
                        //   onTap: () {},
                        // ),
                        // SizedBox(height: 2.h),
                        // Ordevider(),
                        // SizedBox(height: 2.h),
                        CustomTextField(
                          controller: phoneController,
                          label: "Enter Mobile No",
                          hintText: "Enter Mobile No",
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              ValidateCheck.validatePhoneNumber(value),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        widget.isFromOtpVerification
                            ? SizedBox(height: 2.h)
                            : SizedBox(),
                        widget.isFromOtpVerification
                            ? PasswordField(
                                controller: passwordController,
                                label: "Enter Password",
                                hintText: "Enter Password",
                                validator: (value) =>
                                    ValidateCheck.validatePassword(value),
                              )
                            : SizedBox(),
                        widget.isFromOtpVerification
                            ? SizedBox(height: 1.h)
                            : SizedBox(),
                        widget.isFromOtpVerification
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () async {
                                    if (phoneController.text.isEmpty) {
                                      showCustomSnackBar(
                                        'Please enter mobile number',
                                        context,
                                        isError: true,
                                      );
                                    } else {
                                      ResponseModel response =
                                          await authController.login(
                                            phoneController.text.trim(),
                                            isFromForgetPassword: true,
                                          );

                                      if (response.isSuccess) {
                                      } else {
                                        showCustomSnackBar(
                                          response.message,
                                          Get.context!,
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 3.h),
                        PrimaryButton(
                          text: authController.isLoading
                              ? 'Please wait...'
                              : 'Login',
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          isLoading: authController.isLoading,
                          onPressed: widget.isFromOtpVerification
                              ? authController.isLoading
                                    ? null
                                    : () async {
                                        if (signInFormKey.currentState!
                                            .validate()) {
                                          ResponseModel response =
                                              await authController
                                                  .loginWithPassword(
                                                    phoneController.text.trim(),
                                                    passwordController.text,
                                                  );

                                          if (response.isSuccess) {
                                            phoneController.clear();
                                            passwordController.clear();
                                          } else {
                                            showCustomSnackBar(
                                              response.message,
                                              Get.context!,
                                            );
                                          }
                                        }
                                      }
                              : authController.isLoading
                              ? null
                              : () async {
                                  if (signInFormKey.currentState!.validate()) {
                                    ResponseModel response =
                                        await authController.login(
                                          phoneController.text.trim(),
                                        );

                                    if (response.isSuccess) {
                                      // phoneController.clear();
                                    } else {
                                      showCustomSnackBar(
                                        response.message,
                                        Get.context!,
                                      );
                                    }
                                  }
                                },
                        ),

                        // SizedBox(height: 2.h),
                        // AuthFooter(
                        //   text: "Don't have an account? ",
                        //   linkText: 'Sign up',
                        //   onLinkTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => SignUpScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
