import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockModel extends StatefulWidget {
  final double size;
  ClockModel({@required this.size});
  @override
  _ClockModelState createState() => _ClockModelState();
}

class _ClockModelState extends State<ClockModel> {
  Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
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
    // print(datetime);
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    Paint fillBrush = Paint()..color = Color(0xFF444974);
    Paint coreBrush = Paint()..color = Color(0xFFEAECFF);
    Paint outlinedBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 20;
    Paint secHandBrush = Paint()
      ..color = Colors.orange[300]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 60;
    Paint minHandBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [Color(0xFF748EF6), Color(0XFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 30;
    Paint hrsHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Color(0xFFEAECFF)
      ..shader = RadialGradient(colors: [Color(0XFFEA74AB), Color(0XFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 24;
    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlinedBrush);

    var hrsHandX = centerX +
        radius *
            0.4 *
            cos((datetime.hour * 30 + datetime.minute * 0.5) * pi / 180);
    var hrsHandY = centerY + radius * 0.4 * sin(datetime.hour * 30 * pi / 180);
    canvas.drawLine(center, Offset(hrsHandX, hrsHandY), hrsHandBrush);

    var minHandX = centerX + radius * 0.6 * cos(datetime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.6 * sin(datetime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + radius * 0.6 * cos(datetime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.6 * sin(datetime.second * 6 * pi / 180);

    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    canvas.drawCircle(center, radius * 0.12, coreBrush);
    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (double i = 0; i < 360; i += 10) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
