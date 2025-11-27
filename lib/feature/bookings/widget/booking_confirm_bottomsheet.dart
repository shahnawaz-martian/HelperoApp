import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/view/booking_details.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';

class BookingConfirmBottomsheet extends StatefulWidget {
  final String orderId;
  const BookingConfirmBottomsheet({super.key, required this.orderId});

  @override
  State<BookingConfirmBottomsheet> createState() =>
      _BookingConfirmBottomsheetState();
}

class _BookingConfirmBottomsheetState extends State<BookingConfirmBottomsheet> {
  bool _hasNavigated = false;

  void navigateToDetails() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    Navigator.of(Get.context!).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BookingDetails(bookingId: widget.orderId),
      ),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pop(context);
        navigateToDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/account_success_check.png',
            height: 20.h,
            width: 20.w,
          ),
          Text(
            "Booking Created Successfully",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Congratulations!",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 1.5.w),
              Icon(Icons.celebration, color: Colors.orange, size: 24),
            ],
          ),
          SizedBox(height: 0.3.h),
          Text(
            "Your booking has been created",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToDetails();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "View Booking Summary",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
        ],
      ),
    );
  }
}
