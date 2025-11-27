import 'package:flutter/material.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/feature/profile/view/nevigation/edit_profile/view/edit_profile.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/view/my_address.dart';
import 'package:helpero/feature/profile/view/nevigation/privacy_policy/view/privacy_policy.dart';
import 'package:helpero/feature/profile/view/nevigation/terms&condition/view/terms_and_condition.dart';
import 'package:helpero/feature/profile/widget/logout_dialog.dart';
import 'package:helpero/main.dart';
import 'package:helpero/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/view/set_password/view/set_password.dart';
import '../../navigation/bottom_navigation_bar_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEligible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contact = await _loadUserProfile();
      await _checkEligibility(contact: contact);
    });
  }

  Future<String?> _loadUserProfile() async {
    final profileProvider = Provider.of<ProfileController>(
      context,
      listen: false,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString(AppConstants.userId);

    await profileProvider.getUserInfo(Get.context!, userId!);

    return profileProvider.userInfoModel?.contactNo;
  }

  Future<void> _checkEligibility({String? contact}) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final isEligible = await authController.checkLoginWithPassEligibility(
      contact ?? '',
    );
    setState(() {
      _isEligible = isEligible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Consumer<ProfileController>(
            builder: (context, profileProvider, _) {
              final profile = profileProvider.userInfoModel;
              String imageUrl = profile?.profileImageUrl ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Column(
                      children: [
                        // Square profile image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                          child: Container(
                            width: 30.w,
                            height: 13.h,
                            color: Theme.of(context).highlightColor,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  buildRow(
                    context,
                    'assets/images/icons/edit_profile_light.png',
                    'assets/images/icons/edit_profile_dark.png',
                    'Edit Profile',
                    () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        )
                        .then((_) {
                          _loadUserProfile();
                        }),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  buildRow(
                    context,
                    'assets/images/icons/change_password_light.png',
                    'assets/images/icons/change_password_dark.png',
                    'Change Password',
                    () => Navigator.of(Get.context!)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => SetPassword(
                              phoneNumber: profile?.contactNo,
                              userId: profile?.userId,
                              isEligible: _isEligible,
                              isForgetPassword: false,
                              changePassword: true,
                            ),
                          ),
                        )
                        .then((_) {
                          _checkEligibility(contact: profile?.contactNo);
                        }),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  buildRow(
                    context,
                    'assets/images/bottom_navigation_icon/booking_page_light.png',
                    'assets/images/bottom_navigation_icon/booking_page_dark.png',
                    'My Bookings',
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BottomNavigationBarScreen(initialIndex: 1),
                      ),
                    ),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  buildRow(
                    context,
                    'assets/images/icons/address_light.png',
                    'assets/images/icons/address_dark.png',
                    'My Addresses',
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyAddresses()),
                    ),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  buildRow(
                    context,
                    'assets/images/icons/privacy_policy_light.png',
                    'assets/images/icons/privacy_policy_dark.png',
                    'Privacy Policy',
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    ),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  buildRow(
                    context,
                    'assets/images/icons/terms-and-conditions_light.png',
                    'assets/images/icons/terms-and-condition_dark.png',
                    'Terms & Conditions',
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TermsAndCondition(),
                      ),
                    ),
                  ),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: LogoutDialog(),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/logout.png',
                          width: 5.w,
                          height: 5.h,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            'Logout',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildRow(
    BuildContext context,
    String lightImage,
    String darkImage,
    String text,
    VoidCallback onTap,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            isDarkMode ? darkImage : lightImage,
            width: 5.w,
            height: 5.h,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }
}
