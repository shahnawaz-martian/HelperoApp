import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RemoveFromAddressBottomSheet extends StatelessWidget {
  final int addressId;
  final int index;

  const RemoveFromAddressBottomSheet({
    super.key,
    required this.addressId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
            size: 60,
          ),

          SizedBox(height: 2.h),

          Text(
            "Remove this address?",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.5.h),

          Text(
            "Are you sure you want to remove this address?\nThis action cannot be undone.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              SizedBox(width: 2.5.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(
                    "Delete",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
