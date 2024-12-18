// Custom Semicircular Progress Indicator
import 'dart:math';

import 'package:flutter/material.dart';

class SemicircularProgressIndicator extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  const SemicircularProgressIndicator({
    super.key,
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 100),
      painter: _SemicircularProgressPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
    );
  }
}

class _SemicircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _SemicircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final paintProgress = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height), radius: size.width / 2);
    const startAngle = -pi; // Starting from the left side of the semicircle
    final sweepAngle =
        pi * progress; // Progress determines how much of the semicircle to fill

    // Draw the background (full circle)
    canvas.drawArc(rect, startAngle, pi, false, paintBackground);

    // Draw the progress (portion of the semicircle)
    canvas.drawArc(rect, startAngle, sweepAngle, false, paintProgress);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint unless there's a state change
  }
}
