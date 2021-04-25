import 'dart:math';

import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    Paint fillBrush = Paint()..color = Color(0xFF444974);
    Paint outlinedBrush = Paint()
      ..color = Colors.amber //Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0; //5.0

    canvas.drawCircle(center, radius, fillBrush);
    canvas.drawCircle(center, radius, outlinedBrush);

    outlinedBrush.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(
        Offset.zero & size, pi * 1.5, -progress, false, outlinedBrush);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
