import 'package:flutter/material.dart';

class HeaderText extends StatefulWidget {
  final String text;
  final String tapText;
  final VoidCallback onLinkTap;
  const HeaderText({
    super.key,
    required this.text,
    required this.tapText,
    required this.onLinkTap,
  });

  @override
  State<HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        InkWell(
          onTap: widget.onLinkTap,
          child: Text(
            widget.tapText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              letterSpacing: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
