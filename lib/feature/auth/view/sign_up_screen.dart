import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/view/sign_in_screen.dart';
import 'package:helpero/feature/auth/widget/verify_phone_number.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/velidate_check.dart';
import '../../widget/auth_footer.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/password_field.dart';
import '../../widget/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset('assets/images/logo.png', height: 20.h, width: 20.w),
                Text(
                  "Create New Account",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Set up your username and password.\nTou can always change it later.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                CustomTextField(
                  controller: userNameController,
                  label: "Enter Username",
                  hintText: "Enter Username",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => ValidateCheck.validateEmptyText(
                    value,
                    "Username is required",
                  ),
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  controller: emailController,
                  label: "Enter Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => ValidateCheck.validateEmail(value),
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  controller: mobileNoController,
                  label: "Enter Mobile Number",
                  hintText: "Enter Mobile Number",
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      ValidateCheck.validatePhoneNumber(value),
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  controller: addressLine1Controller,
                  label: "Address Line 1",
                  hintText: "Enter Address Line 1",
                  keyboardType: TextInputType.streetAddress,
                  validator: null, // Optional, so no validation
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  controller: addressLine2Controller,
                  label: "Address Line 2",
                  hintText: "Enter Address Line 2",
                  keyboardType: TextInputType.streetAddress,
                  validator: null,
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: cityController,
                        label: "City",
                        hintText: "Enter City",
                        keyboardType: TextInputType.text,
                        validator: null,
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: CustomTextField(
                        controller: postalCodeController,
                        label: "Postal Code",
                        hintText: "Enter Postal Code",
                        keyboardType: TextInputType.number,
                        validator: null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  controller: stateController,
                  label: "State",
                  hintText: "Enter State",
                  keyboardType: TextInputType.text,
                  validator: null,
                ),
                SizedBox(height: 1.5.h),
                PasswordField(
                  controller: passwordController,
                  label: "Enter Password",
                  hintText: "Enter Password",
                  validator: (value) => ValidateCheck.validatePassword(value),
                ),
                SizedBox(height: 1.5.h),
                PasswordField(
                  controller: confirmPasswordController,
                  label: "Enter Confirm Password",
                  hintText: "Confirm Password",
                  validator: (value) => ValidateCheck.validateConfirmPassword(
                    value,
                    passwordController.text,
                  ),
                ),
                SizedBox(height: 2.5.h),
                PrimaryButton(
                  text: 'Signup',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    if (signUpFormKey.currentState!.validate()) {
                      userNameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      mobileNoController.clear();
                      confirmPasswordController.clear();
                      addressLine1Controller.clear();
                      addressLine2Controller.clear();
                      postalCodeController.clear();
                      cityController.clear();
                      stateController.clear();
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: VerifyPhoneNumber(),
                          );
                        },
                      );
                    }
                  },
                ),
                SizedBox(height: 1.5.h),
                AuthFooter(
                  text: "Already have an account? ",
                  linkText: 'Sign in',
                  onLinkTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
