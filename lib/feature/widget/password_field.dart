import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.textDirection, // NEW
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.label,
        //   style: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.normal,
        //     color: Colors.orangeAccent,
        //   ),
        //   textDirection:
        //       widget.textDirection ?? TextDirection.ltr, // Apply here
        // ),
        // const SizedBox(height: 8),
        TextFormField(
          style: TextStyle(fontSize: 14),
          controller: widget.controller,
          obscureText: _obscureText,
          textDirection:
              widget.textDirection ?? TextDirection.ltr, // Apply here
          decoration: InputDecoration(
            label: Text(widget.label),
            // hintText: widget.hintText,
            // hintStyle: const TextStyle(color: Color(0xFF808080)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            labelStyle: TextStyle(color: Color(0xFF808080), fontSize: 14),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
