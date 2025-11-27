import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DotsFlickerLoading extends StatefulWidget {
  const DotsFlickerLoading({super.key});

  @override
  State<DotsFlickerLoading> createState() => _DotsFlickerLoadingState();
}

class _DotsFlickerLoadingState extends State<DotsFlickerLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.progressiveDots(
          size: 50,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
