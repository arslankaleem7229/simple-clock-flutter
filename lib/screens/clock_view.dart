import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var datetime = DateTime.now();
  // datetie gives us current time. Now
  // 60 sec / min = 360/60 = 6 degree
  @override
  void paint(Canvas canvas, Size size) {
    print(datetime);
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    Paint fillBrush = Paint()..color = Color(0xFF444974);
    Paint coreBrush = Paint()..color = Color(0xFFEAECFF);
    Paint outlinedBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;
    Paint secHandBrush = Paint()
      ..color = Colors.orange[300]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Paint minHandBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [Color(0xFF748EF6), Color(0XFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Paint hrsHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Color(0xFFEAECFF)
      ..shader = RadialGradient(colors: [Color(0XFFEA74AB), Color(0XFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlinedBrush);

    var hrsHandX = centerX +
        (radius / 2.5) *
            cos((datetime.hour * 30 + datetime.minute * 0.5) * pi / 180);
    var hrsHandY =
        centerY + (radius / 2.5) * sin(datetime.hour * 30 * pi / 180);
    canvas.drawLine(center, Offset(hrsHandX, hrsHandY), hrsHandBrush);

    var minHandX =
        centerX + (radius / 2.0) * cos(datetime.minute * 6 * pi / 180);
    var minHandY =
        centerY + (radius / 2.0) * sin(datetime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX =
        centerX + (radius / 1.7) * cos(datetime.second * 6 * pi / 180);
    var secHandY =
        centerY + (radius / 1.7) * sin(datetime.second * 6 * pi / 180);

    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    canvas.drawCircle(center, 16, coreBrush);
    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
