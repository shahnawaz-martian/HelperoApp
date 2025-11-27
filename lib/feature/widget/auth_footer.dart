import 'package:flutter/material.dart';

class AuthFooter extends StatefulWidget {
  final String text;
  final String linkText;
  final VoidCallback onLinkTap;

  const AuthFooter({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  State<AuthFooter> createState() => _AuthFooterState();
}

class _AuthFooterState extends State<AuthFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            letterSpacing: 1.2,
          ),
        ),
        GestureDetector(
          onTap: widget.onLinkTap,
          child: Text(
            widget.linkText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
