import 'package:flutter/material.dart';

class SocialLoginButton extends StatefulWidget {
  final String text;
  final String logo;
  final VoidCallback onTap;
  const SocialLoginButton({
    super.key,
    required this.text,
    required this.logo,
    required this.onTap,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        // backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      ),
      onPressed: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.logo, height: 24, width: 24),
          SizedBox(width: 12),
          Text(
            widget.text,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}
