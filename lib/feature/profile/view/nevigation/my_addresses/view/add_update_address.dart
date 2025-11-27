import 'package:flutter/material.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/bookings/view/create_order.dart';
import 'package:helpero/feature/profile/domain/models/profile_model.dart';
import 'package:helpero/feature/profile/view/nevigation/edit_profile/view/edit_profile.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/view/my_address.dart';
import 'package:helpero/main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../../widget/custom_textfield.dart';
import '../../../../../widget/primary_button.dart';
import '../../../../controllers/profile_contrroller.dart';

class AddUpdateAddress extends StatefulWidget {
  final bool isFromCreateOrder;
  final bool isFromEditProfile;
  final Addresses? selectedAddress;
  final int? index;
  const AddUpdateAddress({
    super.key,
    this.selectedAddress,
    this.index,
    this.isFromCreateOrder = false,
    this.isFromEditProfile = false,
  });

  @override
  State<AddUpdateAddress> createState() => _AddUpdateAddressState();
}

class _AddUpdateAddressState extends State<AddUpdateAddress> {
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final blockNoController = TextEditingController();

  final List<Map<String, dynamic>> addressType = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Office', 'icon': Icons.work},
    {'label': 'Other', 'icon': Icons.location_on},
  ];

  String selectedType = 'Home';

  @override
  void initState() {
    super.initState();

    if (widget.selectedAddress != null) {
      final addr = widget.selectedAddress!;
      addressLine1Controller.text = addr.addressLine1 ?? '';
      addressLine2Controller.text = addr.addressLine2 ?? '';
      cityController.text = addr.city ?? 'Ahmedabad';
      stateController.text = addr.state ?? 'Gujarat';
      postalCodeController.text = addr.pinCode ?? '';
      blockNoController.text = addr.blockNo ?? '';
      selectedType = addr.addressType ?? 'Home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.index != null ? "Update Address" : "Add Address",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            if (widget.isFromCreateOrder) {
              Navigator.pop(context);
            } else if (widget.isFromEditProfile) {
              Navigator.pop(context);
            } else {
              Navigator.of(Get.context!).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MyAddresses()),
                (route) => route.isFirst,
              );
            }
          },
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  "Label as",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 0.5.h),
                Wrap(
                  spacing: 8.0,
                  children: addressType.map((type) {
                    final isSelected = selectedType == type['label'];
                    return ChoiceChip(
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // corner radius
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
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
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(type['label']),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).highlightColor,
                      labelStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
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
                  hintText: "Enter your flat, house or block number",
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
                          color: Theme.of(context).colorScheme.primary,
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
                        validator: null,
                        prefixIcon: Icon(
                          Icons.pin_drop_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
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
                SizedBox(height: 2.5.h),
                Consumer<ProfileController>(
                  builder: (context, profileProvider, _) {
                    return PrimaryButton(
                      text: 'Save Address',
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      isLoading: profileProvider.isLoading,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () async {
                        final profileController =
                            Provider.of<ProfileController>(
                              context,
                              listen: false,
                            );

                        final List<Addresses> currentAddresses =
                            List<Addresses>.from(
                              profileProvider.userInfoModel?.addresses ?? [],
                            );

                        final updatedAddress = Addresses(
                          addressLine1: addressLine1Controller.text,
                          addressLine2: addressLine2Controller.text,
                          city: cityController.text,
                          state: stateController.text,
                          pinCode: postalCodeController.text,
                          addressType: selectedType,
                          distance: widget.selectedAddress?.distance ?? 0.0,
                          blockNo: blockNoController.text,
                        );

                        if (widget.index != null &&
                            widget.index! >= 0 &&
                            widget.index! < currentAddresses.length) {
                          currentAddresses[widget.index!] = updatedAddress;
                        } else {
                          currentAddresses.add(updatedAddress);
                        }

                        final payload = {
                          "user_id": Provider.of<AuthController>(
                            context,
                            listen: false,
                          ).getUserId(),
                          "contact_no":
                              profileProvider.userInfoModel?.contactNo ?? '',
                          "addresses": currentAddresses
                              .map((e) => e.toJson())
                              .toList(),
                        };

                        final response = await profileController
                            .updateUserAddress(payload);

                        if (response.isSuccess) {
                          Future.microtask(() {
                            if (widget.isFromCreateOrder) {
                              Navigator.pop(Get.context!, updatedAddress);
                            } else if (widget.isFromEditProfile) {
                              Navigator.pop(Get.context!, updatedAddress);
                            } else {
                              Navigator.of(Get.context!).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MyAddresses(),
                                ),
                                (route) => route.isFirst,
                              );
                            }
                          });
                        } else {
                          showCustomSnackBar(
                            "Failed to update address",
                            Get.context!,
                          );
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
    );
  }
}
