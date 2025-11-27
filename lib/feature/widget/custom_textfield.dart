import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final void Function()? onTap;
  final TextDirection? textDirection;
  final ValueChanged<String>? onChanged;
  final bool required; // Added onChanged parameter

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.textDirection,
    this.onChanged,
    this.required = false,
    this.prefixIcon, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    // Create a local controller if none is provided
    final localController = controller ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: Theme.of(context).primaryColor,
        //     fontWeight: FontWeight.w400,
        //   ),
        //   textDirection: textDirection ?? TextDirection.ltr,
        // ),
        // const SizedBox(height: 8),
        TextFormField(
          style: TextStyle(fontSize: 14),
          controller: localController,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged, // Added onChanged
          textDirection: textDirection ?? TextDirection.ltr,
          decoration: InputDecoration(
            label: Text(label),
            hintText: hintText,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Color(0xFF808080)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            filled: !enabled,
            fillColor: !enabled ? Colors.grey[200] : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: enabled ? const Color(0xFFE9E9E9) : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            labelStyle: TextStyle(color: Color(0xFF808080), fontSize: 14),
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
