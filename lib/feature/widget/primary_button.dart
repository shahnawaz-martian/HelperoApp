import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isLoading;
  final double fontSize; // Added fontSize parameter

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height = 50,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 8,
    this.isLoading = false,
    this.fontSize = 16, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? Theme.of(context).disabledColor
              : backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed as void Function()?,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 18, // Use fontSize parameter
                  color: textColor,
                  fontFamily: "Poppins",
                ),
              ),
      ),
    );
  }
}
