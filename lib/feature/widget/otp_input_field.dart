import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final Function(String) onChanged;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.autoFocus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surface;

    return SizedBox(
      width: 14.w,
      height: 6.h,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: backgroundColor,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
