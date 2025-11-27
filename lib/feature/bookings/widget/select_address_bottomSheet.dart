import 'package:flutter/material.dart';
import 'package:helpero/feature/profile/domain/models/profile_model.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/widget/search_address.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../profile/controllers/profile_contrroller.dart';

class SelectAddressBottomSheet extends StatefulWidget {
  final Addresses? selectedAddress;
  const SelectAddressBottomSheet({super.key, this.selectedAddress});

  @override
  State<SelectAddressBottomSheet> createState() =>
      _SelectAddressBottomSheetState();
}

class _SelectAddressBottomSheetState extends State<SelectAddressBottomSheet> {
  Addresses? selectedAddress;
  List<Addresses>? addresses;

  @override
  void initState() {
    super.initState();

    addresses = Provider.of<ProfileController>(
      context,
      listen: false,
    ).userInfoModel?.addresses;

    if (widget.selectedAddress != null) {
      selectedAddress = widget.selectedAddress;
    } else if (addresses != null && addresses!.isNotEmpty) {
      selectedAddress = addresses!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profile, child) {
        final addresses = profile.userInfoModel?.addresses ?? [];
        selectedAddress = addresses!.first;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------- Header ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Address",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context, selectedAddress),
                  ),
                ],
              ),

              Divider(color: Theme.of(context).colorScheme.outline),

              // ---------- Address List ----------
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: addresses?.length ?? 0,
                  itemBuilder: (context, index) {
                    final address = addresses![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: RadioListTile<Addresses>(
                          value: address,
                          groupValue: selectedAddress,
                          onChanged: (value) {
                            setState(() {
                              selectedAddress = value; // update selected
                            });

                            Navigator.pop(context, value); // return selected
                          },

                          activeColor: Theme.of(context).colorScheme.primary,
                          title: Text(
                            address.addressType ?? "",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "${address.blockNo ?? ''} "
                            "${address.addressLine1 ?? ''} "
                            "${address.addressLine2 ?? ''} "
                            "${address.city ?? ''} "
                            "${address.state ?? ''} "
                            "${address.pinCode ?? ''}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 1.h),

              SizedBox(
                width: 100.w,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchAddress(isFromCreateOrder: true),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 2.w),
                      Text(
                        "Add New Address",
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 1.5.h),
            ],
          ),
        );
      },
    );
  }
}
