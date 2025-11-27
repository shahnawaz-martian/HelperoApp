import 'package:flutter/material.dart';
import 'package:helpero/feature/category/view/category_screen.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:sizer/sizer.dart';

class ReviewSuccessBottomsheet extends StatefulWidget {
  const ReviewSuccessBottomsheet({super.key});

  @override
  State<ReviewSuccessBottomsheet> createState() =>
      _ReviewSuccessBottomsheetState();
}

class _ReviewSuccessBottomsheetState extends State<ReviewSuccessBottomsheet> {
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
            "Thanks for giving your feedback",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            "Your feedback means a lot for the rating and improvement of our service",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: 100.w,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BottomNavigationBarScreen(initialIndex: 2),
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
                "Done",
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
