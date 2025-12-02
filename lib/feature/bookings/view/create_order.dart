import 'package:flutter/material.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:helpero/feature/profile/domain/models/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../main.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../../../base_widget/add_address_popup.dart';
import '../widget/create_order_form.dart';

class CreateOrder extends StatefulWidget {
  final bool isSubscription;
  const CreateOrder({super.key, this.isSubscription = false});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  ProfileModel? user;
  Addresses? selectedAddressInAppBar;

  @override
  void initState() {
    super.initState();

    final profile = Provider.of<ProfileController>(context, listen: false);
    user = profile.userInfoModel;

    if (user?.addresses != null && user!.addresses!.isNotEmpty) {
      selectedAddressInAppBar = user!.addresses!.first;
    } else {
      selectedAddressInAppBar = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addresses = user?.addresses;

      if (addresses == null || addresses.isEmpty) {
        final newAddress = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: AddAddressPopup(
                isFromCreateOrder: true,
                isFromEditProfile: false,
              ),
            );
          },
        );

        if (newAddress != null) {
          selectedAddressInAppBar = newAddress;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: -9,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 7.w),
              child: InkWell(
                onTap: () => Navigator.of(Get.context!).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(),
                  ),
                  (route) => false,
                ),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            SizedBox(width: 0.5.w),
            Expanded(
              child: Text(
                selectedAddressInAppBar != null
                    ? '${selectedAddressInAppBar!.blockNo ?? ''} ${selectedAddressInAppBar!.addressLine1 ?? ''}'
                    : '',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      body: CreateOrderForm(
        isSubscription: widget.isSubscription,
        user: user,
        onAddressSelected: (address) {
          setState(() {
            selectedAddressInAppBar = address;
          });
        },
      ),
    );
  }
}
