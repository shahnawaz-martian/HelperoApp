import 'package:flutter/material.dart';

class Ordevider extends StatelessWidget {
  const Ordevider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(color: Colors.grey.shade300),
          ),
        ),
        Text("OR", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }
}
