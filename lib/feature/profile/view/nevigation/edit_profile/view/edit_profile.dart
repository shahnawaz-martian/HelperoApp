import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/auth/view/set_password/view/set_password.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/feature/profile/domain/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../helper/velidate_check.dart';
import '../../../../../../main.dart';
import '../../../../../../base_widget/add_address_popup.dart';
import '../../../../../widget/custom_textfield.dart';
import '../../../../../widget/primary_button.dart';
import 'package:http/http.dart' as http;

import '../../../../controllers/address_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final blockNoController = TextEditingController();
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  bool? _isEligible;
  double _selectedDistance = 0.0;
  String selectedType = 'Home';
  final List<Map<String, dynamic>> addressType = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Office', 'icon': Icons.work},
    {'label': 'Other', 'icon': Icons.location_on},
  ];

  bool _initialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final profileProvider = Provider.of<ProfileController>(
      context,
      listen: false,
    );

    _fillProfile(profileProvider);
    if (!_initialized) {
      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final profile = profileProvider.userInfoModel;

        if (profile?.addresses == null || profile!.addresses!.isEmpty) {
          await showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: AddAddressPopup(isFromEditProfile: true),
            ),
          );

          await profileProvider.getUserInfo(Get.context!, profile!.userId!);

          _fillProfile(profileProvider);

          setState(() {});
        }

        _checkEligibility();
      });
    }
  }

  void _fillProfile(ProfileController provider) {
    final profile = provider.userInfoModel;
    if (profile == null) return;

    firstNameController.text = profile.firstName ?? '';
    lastNameController.text = profile.lastName ?? '';
    emailController.text = profile.email ?? '';
    mobileNoController.text = profile.contactNo ?? '';
    passwordController.text = profile.password ?? '';
    confirmPasswordController.text = profile.password ?? '';

    if (profile.addresses != null && profile.addresses!.isNotEmpty) {
      final addr = profile.addresses!.first;

      addressLine1Controller.text = addr.addressLine1 ?? '';
      addressLine2Controller.text = addr.addressLine2 ?? '';
      cityController.text = addr.city ?? '';
      stateController.text = addr.state ?? '';
      postalCodeController.text = addr.pinCode ?? '';
      blockNoController.text = addr.blockNo ?? '';

      selectedType = addr.addressType ?? selectedType;
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final profileProvider = Provider.of<ProfileController>(context);
  //
  //   _fillProfile(profileProvider);
  //
  //   if (!_initialized) {
  //     _initialized = true;
  //
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       final profile = profileProvider.userInfoModel;
  //
  //       if (profile?.addresses == null || profile!.addresses!.isEmpty) {
  //         showDialog(
  //           context: context,
  //           builder: (_) => Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: AddAddressPopup(isFromEditProfile: true),
  //           ),
  //         );
  //       }
  //       _checkEligibility();
  //     });
  //   }
  // }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    final tempDir = await getTemporaryDirectory();

    final uri = Uri.parse(imageUrl);
    String fileName = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : 'image';
    if (!fileName.contains('.')) {
      fileName = '$fileName.jpg';
    }

    final filePath = '${tempDir.path}/$fileName';

    final response = await http.get(uri);

    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception("Invalid image URL or empty response");
    }

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<void> _checkEligibility() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final profile = Provider.of<ProfileController>(
      context,
      listen: false,
    ).userInfoModel;
    final isEligible = await authController.checkLoginWithPassEligibility(
      profile?.contactNo ?? '',
    );
    setState(() {
      _isEligible = isEligible;
    });
  }

  void _showPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, size: 15),
                title: Text(
                  'Choose from Gallery',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, size: 15),
                title: Text(
                  'Take Photo',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressController = Provider.of<AddressController>(context);
    return Consumer<ProfileController>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.userInfoModel;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Edit Profile",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BottomNavigationBarScreen(initialIndex: 2),
                ),
              ),
              icon: Icon(Icons.arrow_back_ios, size: 20),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: SingleChildScrollView(
                child: Consumer<ProfileController>(
                  builder: (context, profileProvider, _) {
                    return Form(
                      key: editProfileFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    // Square profile image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // Rounded corners
                                      child: Container(
                                        width: 30.w,
                                        height: 13.h,
                                        color: Colors.grey[300],
                                        child: _imageFile != null
                                            ? Image.file(
                                                _imageFile!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              )
                                            : (profile?.profileImageUrl !=
                                                      null &&
                                                  profile!
                                                      .profileImageUrl!
                                                      .isNotEmpty &&
                                                  (profile!.profileImageUrl!
                                                          .startsWith(
                                                            'http://',
                                                          ) ||
                                                      profile!.profileImageUrl!
                                                          .startsWith(
                                                            'https://',
                                                          )))
                                            ? Image.network(
                                                profile!.profileImageUrl!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Icon(
                                                      Icons.person,
                                                      size: 70,
                                                      color: Colors.white70,
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 70,
                                                color: Colors.white70,
                                              ),
                                      ),
                                    ),
                                    // Edit camera icon
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: () => _showPickerDialog(context),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                          SizedBox(height: 3.h),
                          CustomTextField(
                            controller: firstNameController,
                            label: "Firstname",
                            hintText: "Enter Firstname",
                            keyboardType: TextInputType.emailAddress,
                            // validator: (value) => ValidateCheck.validateEmptyText(
                            //   value,
                            //   "Firstname is required",
                            // ),
                            validator: null,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          CustomTextField(
                            controller: lastNameController,
                            label: "Lastname",
                            hintText: "Enter Lastname",
                            keyboardType: TextInputType.emailAddress,
                            // validator: (value) => ValidateCheck.validateEmptyText(
                            //   value,
                            //   "Lastname is required",
                            // ),
                            validator: null,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          CustomTextField(
                            controller: emailController,
                            label: "Email",
                            hintText: "Enter Email",
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                ValidateCheck.validateEmail(value),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          CustomTextField(
                            controller: mobileNoController,
                            label: "Mobile Number",
                            hintText: "Enter Mobile Number",
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                ValidateCheck.validatePhoneNumber(value),
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 1.5.h),
                          if (profile?.addresses != null &&
                              profile!.addresses!.isNotEmpty) ...[
                            Text(
                              "Label as",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 0.5.h),
                            Wrap(
                              spacing: 8.0,
                              children: addressType.map((type) {
                                final isSelected =
                                    selectedType == type['label'];
                                return ChoiceChip(
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ), // corner radius
                                    side: BorderSide(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context).highlightColor,
                                      width: 1,
                                    ),
                                  ),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        type['icon'],
                                        size: 18,
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(type['label']),
                                    ],
                                  ),
                                  selected: isSelected,
                                  selectedColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).highlightColor,
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedType = type['label'];
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 1.5.h),
                            CustomTextField(
                              controller: blockNoController,
                              label: "Flat / House / Block No (optional)",
                              hintText:
                                  "Enter your flat, house or block number",
                              keyboardType: TextInputType.text,
                              validator: null,
                              prefixIcon: Icon(
                                Icons.apartment_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(height: 1.5.h),

                            CustomTextField(
                              controller: addressLine1Controller,
                              label: "Address Line 1",
                              hintText: "Enter Address Line 1",
                              keyboardType: TextInputType.streetAddress,
                              validator: null,
                              prefixIcon: Icon(
                                Icons.home_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              onChanged: (value) {
                                if (value.length > 2) {
                                  addressController.getPlaceSuggestions(value);
                                } else {
                                  addressController.suggestions = [];
                                }
                              },
                            ),
                            if (addressController.suggestions.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      addressController.suggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion =
                                        addressController.suggestions[index];
                                    return InkWell(
                                      onTap: () async {
                                        final place = await addressController
                                            .fetchPlaceDetails(
                                              suggestion['place_id'],
                                            );
                                        if (place == null) return;

                                        final lat = place['latitude'];
                                        final lng = place['longitude'];

                                        if (lat != null && lng != null) {
                                          var isAllowed =
                                              await addressController
                                                  .isAllowedLocationByLatLng(
                                                    lat,
                                                    lng,
                                                  );

                                          if (!isAllowed) {
                                            addressController.suggestions
                                                .clear();
                                            addressController.notifyListeners();
                                            showCustomSnackBar(
                                              "Sorry! We are not serviceable yet for your location ${place['formattedAddress'] ?? "Selected Location"}",
                                              Get.context!,
                                            );
                                            return;
                                          }
                                        }

                                        double distance = 0.0;
                                        if (lat != null && lng != null) {
                                          distance =
                                              await addressController
                                                  .getDistanceFromOffice(
                                                    lat,
                                                    lng,
                                                  ) ??
                                              0.0;
                                        }

                                        setState(() {
                                          addressLine1Controller.text =
                                              place['addressLine1'] ?? '';
                                          addressLine2Controller.text =
                                              place['addressLine2'] ?? '';
                                          cityController.text =
                                              place['city'] ?? '';
                                          stateController.text =
                                              place['state'] ?? '';
                                          postalCodeController.text =
                                              place['postalCode'] ?? '';
                                          _selectedDistance = distance;
                                        });

                                        addressController.suggestions.clear();
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 7,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                suggestion['description'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            SizedBox(height: 1.5.h),

                            CustomTextField(
                              controller: addressLine2Controller,
                              label: "Address Line 2",
                              hintText: "Enter Address Line 2",
                              keyboardType: TextInputType.streetAddress,
                              validator: null,
                              prefixIcon: Icon(
                                Icons.home_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
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
                                    prefixIcon: Icon(
                                      Icons.location_city_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.5.w),
                                Expanded(
                                  child: CustomTextField(
                                    controller: postalCodeController,
                                    label: "Postal Code",
                                    hintText: "Enter Postal Code",
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icon(
                                      Icons.pin_drop_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size: 20,
                                    ),
                                    validator: (value) =>
                                        ValidateCheck.validatePostalCode(value),
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
                              prefixIcon: Icon(
                                Icons.account_tree_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(height: 1.5.h),
                          ],
                          Consumer<AuthController>(
                            builder: (context, authController, _) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(Get.context!)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) => SetPassword(
                                              phoneNumber: profile?.contactNo,
                                              userId: profile?.userId,
                                              isEligible: _isEligible,
                                              isForgetPassword: false,
                                            ),
                                          ),
                                        )
                                        .then((_) {
                                          _checkEligibility();
                                        });
                                  },
                                  child: Text(
                                    (_isEligible ?? false)
                                        ? "Update Password"
                                        : "Set Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          decorationColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.5.h),
                          PrimaryButton(
                            text: 'Update Profile',
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            isLoading: profileProvider.isLoading,
                            onPressed: profileProvider.isLoading
                                ? null
                                : () async {
                                    if (editProfileFormKey.currentState!
                                        .validate()) {
                                      File? fileToUpload = _imageFile;

                                      if (_imageFile != null) {
                                        fileToUpload = _imageFile!;
                                      } else if (profile?.profileImageUrl !=
                                              null &&
                                          profile!
                                              .profileImageUrl!
                                              .isNotEmpty &&
                                          profile!.profileImageUrl!.startsWith(
                                            "http",
                                          )) {
                                        fileToUpload = await urlToFile(
                                          profile!.profileImageUrl!,
                                        );
                                      }

                                      final originalAddresses =
                                          profile?.addresses ?? [];

                                      Addresses? updatedFirstAddress;
                                      if (originalAddresses.isNotEmpty) {
                                        updatedFirstAddress = Addresses(
                                          addressLine1:
                                              addressLine1Controller.text,
                                          addressLine2:
                                              addressLine2Controller.text,
                                          city: cityController.text,
                                          state: stateController.text,
                                          pinCode: postalCodeController.text,
                                          blockNo: blockNoController.text,
                                          distance: _selectedDistance,
                                          addressType: selectedType,
                                        );
                                      }

                                      final updatedAddresses = [
                                        if (updatedFirstAddress != null)
                                          updatedFirstAddress,
                                        ...originalAddresses.skip(1),
                                      ];

                                      final payload = ProfileModel(
                                        userId: profile?.userId,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        contactNo: mobileNoController.text,
                                        profileImage: fileToUpload,
                                        profileImageUrl:
                                            profile?.profileImageUrl,
                                        addresses: updatedAddresses,
                                      );

                                      await profileProvider.updateUserInfo(
                                        payload,
                                      );

                                      setState(() {
                                        _imageFile = null;
                                      });
                                    }
                                  },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
