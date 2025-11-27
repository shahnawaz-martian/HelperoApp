import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../helper/velidate_check.dart';
import '../../../../profile/controllers/profile_contrroller.dart';
import '../../../../widget/password_field.dart';
import '../../../../widget/primary_button.dart';
import 'package:http/http.dart' as http;

class SetPassword extends StatefulWidget {
  final String? phoneNumber;
  final String? userId;
  final bool isForgetPassword;
  final bool? isEligible;
  final bool changePassword;
  const SetPassword({
    super.key,
    required this.phoneNumber,
    this.userId,
    this.isForgetPassword = false,
    this.isEligible,
    this.changePassword = false,
  });

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUserProfile();
      });
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    if (imageUrl.isEmpty || !(imageUrl.startsWith('http'))) {
      throw Exception("Invalid URL passed to urlToFile");
    }

    final tempDir = await getTemporaryDirectory();
    final uri = Uri.parse(imageUrl);

    String fileName = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : 'image.jpg';
    if (!fileName.contains('.')) fileName = '$fileName.jpg';

    final filePath = '${tempDir.path}/$fileName';

    final response = await http.get(uri);

    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception("Error downloading file");
    }

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<void> _loadUserProfile() async {
    final profileProvider = Provider.of<ProfileController>(
      context,
      listen: false,
    );
    await profileProvider.getUserInfo(Get.context!, widget.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.userId != null && widget.isEligible == true
              ? "Update Password"
              : "Set Password",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: widget.userId != null
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios, size: 20),
              )
            : SizedBox(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.userId != null && widget.isEligible == true)
                    Column(
                      children: [
                        PasswordField(
                          controller: oldPasswordController,
                          label: "Enter Old Password",
                          hintText: "Old Password",
                          validator: (value) =>
                              ValidateCheck.validatePassword(value),
                        ),
                        SizedBox(height: 1.5.h),
                      ],
                    ),
                  PasswordField(
                    controller: passwordController,
                    label: "Enter New Password",
                    hintText: "New Password",
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
                  Consumer<ProfileController>(
                    builder: (context, profileProvider, _) {
                      return PrimaryButton(
                        text: widget.isForgetPassword
                            ? 'Save'
                            : (widget.userId != null &&
                                      widget.isEligible == true
                                  ? 'Update'
                                  : 'Save'),
                        isLoading: profileProvider.isLoading,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final authController = Provider.of<AuthController>(
                              context,
                              listen: false,
                            );

                            final profile = profileProvider.userInfoModel;

                            File? fileToUpload = _imageFile;

                            if (fileToUpload == null &&
                                profile?.profileImageUrl != null) {
                              final img = profile!.profileImageUrl!.trim();

                              if (img.isNotEmpty &&
                                  (img.startsWith('http://') ||
                                      img.startsWith('https://'))) {
                                try {
                                  fileToUpload = await urlToFile(img);
                                } catch (e) {
                                  debugPrint("Image fetch failed: $e");
                                }
                              } else {
                                debugPrint("Invalid image URL: $img");
                              }
                            }

                            final payload = {
                              "user_id": widget.userId,
                              "contact_no": widget.phoneNumber ?? '',
                              "password": passwordController.text,
                            };

                            print(payload);
                            final response =
                                (widget.userId != null &&
                                    widget.isEligible == true)
                                ? await profileProvider.updatePassword(
                                    userId: widget.userId ?? '',
                                    oldPassword: oldPasswordController.text,
                                    newPassword: passwordController.text,
                                  )
                                : await profileProvider.setPassword(payload);

                            if (response.isSuccess) {
                              {
                                // widget.changePassword
                                //     ? Navigator.of(Get.context!).pop()
                                //     : Navigator.of(
                                //         Get.context!,
                                //       ).pushAndRemoveUntil(
                                //         MaterialPageRoute(
                                //           builder: (context) =>
                                //               BottomNavigationBarScreen(
                                //                 initialIndex: 2,
                                //               ),
                                //         ),
                                //         (route) => false,
                                //       );
                                print(
                                  "Is from forgetpassword = ${widget.isForgetPassword} ",
                                );
                                if (widget.isForgetPassword) {
                                  Navigator.of(Get.context!).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationBarScreen(
                                            initialIndex: 0,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                } else if (widget.changePassword) {
                                  Navigator.of(Get.context!).pop();
                                } else {
                                  Navigator.of(Get.context!).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationBarScreen(
                                            initialIndex: 2,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                }
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
