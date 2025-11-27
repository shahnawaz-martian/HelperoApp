import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LocationPermissionDialog extends StatefulWidget {
  const LocationPermissionDialog({super.key});

  @override
  State<LocationPermissionDialog> createState() =>
      _LocationPermissionDialogState();
}

class _LocationPermissionDialogState extends State<LocationPermissionDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Allow Location Access",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            "To fetch your current location accurately, please allow location access.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: 100.w,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              // style: OutlinedButton.styleFrom(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              //   // side: BorderSide(color: Theme.of(context).colorScheme.primary),
              //   backgroundColor: Theme.of(context).colorScheme.background,
              // ),
              child: Text(
                "GO TO APP SETTINGS",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
