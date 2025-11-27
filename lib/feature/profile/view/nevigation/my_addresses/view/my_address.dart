import 'package:flutter/material.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/widget/search_address.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../main.dart';
import '../../../../../auth/controllers/auth_controller.dart';
import '../../../../domain/models/profile_model.dart';

class MyAddresses extends StatefulWidget {
  final bool isFromCurrentAddress;
  const MyAddresses({super.key, this.isFromCurrentAddress = false});

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  Map<int, bool> deletingMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Address",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BottomNavigationBarScreen(
                initialIndex: widget.isFromCurrentAddress ? 0 : 2,
              ),
            ),
          ),
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),

      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          final addresses = profileController.userInfoModel?.addresses ?? [];

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: addresses.isEmpty
                  ? Center(
                      child: Text(
                        "No addresses found",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 25,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (address.addressType != null &&
                                            address.addressType!.isNotEmpty)
                                          Text(
                                            address.addressType ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          "${address.blockNo != null && address.blockNo!.isNotEmpty ? "${address.blockNo} " : ''}${address.addressLine1 ?? '-'} ${address.addressLine2 ?? ''}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Divider(
                                color: Theme.of(context).colorScheme.outline,
                              ),

                              SizedBox(height: 1.h),
                              buildRow(
                                Icons.location_city_sharp,
                                address.city ?? 'N/A',
                              ),
                              SizedBox(height: 0.7.h),
                              buildRow(
                                Icons.account_tree_outlined,
                                address.state ?? 'N/A',
                              ),
                              SizedBox(height: 0.7.h),
                              buildRow(
                                Icons.pin_drop_outlined,
                                address.pinCode ?? 'N/A',
                              ),

                              Divider(
                                color: Theme.of(context).colorScheme.outline,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SearchAddress(
                                            lastSelectedAddress: address,
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 15,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "Edit",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 20.w),

                                  InkWell(
                                    onTap: () async {
                                      deletingMap[index] = true;
                                      setState(() {});

                                      List<Addresses> updatedAddresses =
                                          List.from(addresses);
                                      updatedAddresses.removeAt(index);

                                      final payload = {
                                        "user_id": Provider.of<AuthController>(
                                          context,
                                          listen: false,
                                        ).getUserId(),
                                        "contact_no":
                                            profileController
                                                .userInfoModel
                                                ?.contactNo ??
                                            '',
                                        "addresses": updatedAddresses
                                            .map((e) => e.toJson())
                                            .toList(),
                                      };

                                      final response = await profileController
                                          .updateUserAddress(payload);

                                      deletingMap[index] = false;
                                      setState(() {});

                                      if (response.isSuccess) {
                                        showCustomSnackBar(
                                          "Address deleted successfully!",
                                          Get.context!,
                                          isError: false,
                                        );

                                        profileController
                                                .userInfoModel
                                                ?.addresses =
                                            updatedAddresses;

                                        print(
                                          "addresses here ${profileController.userInfoModel?.addresses}",
                                        );
                                        profileController.notifyListeners();
                                      } else {
                                        showCustomSnackBar(
                                          "Failed to delete address",
                                          Get.context!,
                                        );
                                      }
                                    },
                                    child: deletingMap[index] == true
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: 12,
                                                height: 12,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                    ),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                "Deleting...",
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Icon(
                                                Icons.delete_outlined,
                                                size: 15,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                "Delete",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                    ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchAddress(
              isFromCreateOrder: false,
              isFromEditProfile: false,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 2.w),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
