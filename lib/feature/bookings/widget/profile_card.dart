import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/controllers/order_controller.dart';
import 'package:helpero/feature/bookings/domain/models/order_detail_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfileCard extends StatefulWidget {
  final bool isFromServiceDetails;
  final HelperDetails profile;
  final String firstname;
  final String lastname;
  final String phoneNo;
  const ProfileCard({
    super.key,
    required this.profile,
    this.isFromServiceDetails = false,
    required this.firstname,
    required this.lastname,
    required this.phoneNo,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 25,
            backgroundImage:
                // widget.profile.imageUrl.isNotEmpty
                //     ? NetworkImage(widget.profile.imageUrl)
                //     :
                const AssetImage('assets/images/user.png') as ImageProvider,
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.profile.firstName ?? ''} ${widget.profile.lastName}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Service Provider",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.5.w),
          widget.isFromServiceDetails
              ? SizedBox()
              : InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Provider.of<OrderController>(
                      context,
                      listen: false,
                    ).openDialer(widget.phoneNo);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.call_rounded,
                      size: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
          // widget.isFromServiceDetails ? SizedBox() : SizedBox(width: 4.w),
          // widget.isFromServiceDetails
          //     ? SizedBox()
          //     : InkWell(
          //         onTap: () {
          //           Provider.of<OrderController>(
          //             context,
          //             listen: false,
          //           ).openSMS(
          //             widget.phoneNo,
          //             message: "Hello, I want to check my booking",
          //           );
          //         },
          //         child: Icon(
          //           Icons.message_outlined,
          //           size: 25,
          //           color: Theme.of(context).colorScheme.primary,
          //         ),
          //       ),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }
}
