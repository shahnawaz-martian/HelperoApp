import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final bool required;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      // style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        label: Text(label),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(
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
            color: enabled ? const Color(0xFFE9E9E9) : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(color: Color(0xFF808080), fontSize: 14),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      validator:
          validator ??
          (value) {
            if (required && value == null) {
              return "Please select $label";
            }
            return null;
          },
      onChanged: enabled ? onChanged : null,
      hint: Text(hintText),
    );
  }
}
