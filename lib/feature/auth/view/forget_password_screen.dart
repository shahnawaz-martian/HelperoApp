import 'package:flutter/material.dart';
import 'package:helpero/feature/widget/auth_header.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/velidate_check.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/primary_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                title: 'Forget Password',
                subtitle:
                    "Enter your registered email address and we’ll send you a link to reset your password.",
              ),
              SizedBox(height: 2.h),
              CustomTextField(
                controller: emailController,
                label: "Enter Email",
                hintText: "Enter Email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) => ValidateCheck.validateEmail(value),
              ),
              SizedBox(height: 3.h),
              PrimaryButton(
                text: 'Send',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  if (formKey.currentState!.validate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
