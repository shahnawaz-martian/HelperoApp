import 'package:flutter/material.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/view/add_update_address.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/widget/search_address.dart';
import 'package:helpero/main.dart';
import 'package:sizer/sizer.dart';

class AddAddressPopup extends StatefulWidget {
  final bool isFromCreateOrder;
  final bool isFromEditProfile;
  const AddAddressPopup({
    super.key,
    this.isFromCreateOrder = false,
    this.isFromEditProfile = false,
  });

  @override
  State<AddAddressPopup> createState() => _AddAddressPopupState();
}

class _AddAddressPopupState extends State<AddAddressPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You haven't added an address yet.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.3.h),
          Text(
            " Please add an address to continue booking.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: 100.w,
            child: OutlinedButton(
              onPressed: () async {
                // Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SearchAddress(
                //       isFromCreateOrder: widget.isFromCreateOrder,
                //       isFromEditProfile: widget.isFromEditProfile,
                //     ),
                //   ),
                // );
                final updatedAddress = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchAddress(
                      isFromCreateOrder: widget.isFromCreateOrder,
                      isFromEditProfile: widget.isFromEditProfile,
                    ),
                  ),
                );

                if (updatedAddress != null) {
                  Navigator.pop(
                    Get.context!,
                    updatedAddress,
                  ); // <-- RETURN RESULT TO EDIT PROFILE
                }
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Add Address",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
