import 'package:flutter/material.dart';

void customSnackBar(
  String? message,
  BuildContext context, {
  bool isError = true,
  Duration duration = const Duration(seconds: 2),
}) {
  if (message == null || message.isEmpty) return;

  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // distance from top
      right: 20, // distance from right
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isError
                  ? const Color(0xFFFF0014)
                  : const Color(0xFF1E7C15),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove after duration
  Future.delayed(duration).then((_) {
    overlayEntry.remove();
  });
}
