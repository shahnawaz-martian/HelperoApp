import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../navigation/bottom_navigation_bar_screen.dart';

class AccountCreateSuccessDialog extends StatefulWidget {
  const AccountCreateSuccessDialog({super.key});

  @override
  State<AccountCreateSuccessDialog> createState() =>
      _AccountCreateSuccessDialogState();
}

class _AccountCreateSuccessDialogState
    extends State<AccountCreateSuccessDialog> {
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
            "Account Created Successfully",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            "Your account created Successfully",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.3.h),
          Text(
            "Ready to book your first service?",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationBarScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Go to Home",
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
