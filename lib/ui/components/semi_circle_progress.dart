import 'dart:math';
import 'package:flutter/material.dart';

class SemicircularProgressIndicator extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final String estimatedDistance;

  const SemicircularProgressIndicator({
    super.key,
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.estimatedDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: const Size(400, 200),
          painter: _SemicircularProgressPainter(
            progress: progress,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
          ),
        ),
        Column(
          children: [
            Text(
              estimatedDistance,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
            const Text('Feet')
          ],
        ),
      ],
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
      ..strokeWidth = 24;

    final paintProgress = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height), radius: size.width / 2);
    const startAngle = -pi; // Starting from the left side of the semicircle
    final sweepAngle = pi * progress;

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
