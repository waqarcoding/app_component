import 'package:flutter/material.dart';

/// A widget that draws a background pattern behind any child.
class PatternBackground extends StatelessWidget {
  /// The child widget to render on top of the pattern
  final Widget child;

  /// Color of the pattern
  final Color patternColor;

  /// Size of each pattern element (dot, square, etc.)
  final double patternSize;

  /// Spacing between pattern elements
  final double patternSpacing;

  /// Type of pattern: dot or line
  final PatternType patternType;

  /// Background color behind pattern
  final Color backgroundColor;

  const PatternBackground({
    super.key,
    required this.child,
    this.patternColor = const Color(0x20FFFFFF), // semi-transparent
    this.patternSize = 4.0,
    this.patternSpacing = 20.0,
    this.patternType = PatternType.dot,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(
        patternColor: patternColor,
        patternSize: patternSize,
        patternSpacing: patternSpacing,
        patternType: patternType,
        backgroundColor: backgroundColor,
      ),
      child: child,
    );
  }
}

enum PatternType { dot, line }

class _PatternPainter extends CustomPainter {
  final Color patternColor;
  final double patternSize;
  final double patternSpacing;
  final PatternType patternType;
  final Color backgroundColor;

  _PatternPainter({
    required this.patternColor,
    required this.patternSize,
    required this.patternSpacing,
    required this.patternType,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.fill;

    // draw background first
    if (backgroundColor != Colors.transparent) {
      canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);
    }

    switch (patternType) {
      case PatternType.dot:
        for (double x = 0; x < size.width; x += patternSpacing) {
          for (double y = 0; y < size.height; y += patternSpacing) {
            canvas.drawCircle(Offset(x, y), patternSize / 2, paint);
          }
        }
        break;
      case PatternType.line:
        for (double y = 0; y < size.height; y += patternSpacing) {
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            paint..strokeWidth = patternSize,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return oldDelegate.patternColor != patternColor ||
        oldDelegate.patternSize != patternSize ||
        oldDelegate.patternSpacing != patternSpacing ||
        oldDelegate.patternType != patternType ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
