import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget? child;

  const AppGradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5B1A73), // purple
            Color(0xFF1F2F45), // blue
            Color(0xFF000000), // black
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    );
  }
}
