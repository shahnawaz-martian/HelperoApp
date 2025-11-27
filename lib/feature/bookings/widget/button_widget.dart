import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback reviewOnTap;
  final VoidCallback bookingOnTap;
  const ButtonWidget({
    super.key,
    required this.reviewOnTap,
    required this.bookingOnTap,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.reviewOnTap,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            child: Text(
              "Write a Review",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.bookingOnTap,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              "Book Again",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
