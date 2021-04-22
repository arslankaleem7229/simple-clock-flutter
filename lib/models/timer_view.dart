import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';

class TimerModel extends StatefulWidget {
  final double size;
  TimerModel({@required this.size});
  @override
  _TimerModelState createState() => _TimerModelState();
}

class _TimerModelState extends State<TimerModel> {
  Timer timer;
  int value;
  int _minuteValue, _secondValue, _hrsValue = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: TimerPainter(),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 20),
              // color: Colors.amber,
              height: 100.0,
              child: Stack(
                children: [
                  // IgnorePointer(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Colors.white.withOpacity(0.1),
                  //           Theme.of(context).primaryColor,
                  //         ],
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // IgnorePointer(
                  //   child: Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             Colors.white.withOpacity(0.1),
                  //             Theme.of(context).primaryColor,
                  //           ],
                  //           begin: Alignment.bottomCenter,
                  //           end: Alignment.topCenter,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.0,
                        height: 100.0,
                        child: ListWheelScrollView.useDelegate(
                          squeeze: 0.5,
                          itemExtent: 25.0,
                          diameterRatio: 1.5,

                          onSelectedItemChanged: (hrs) {
                            _hrsValue = hrs != null ? hrs : 0;
                            print(hrs);
                          },
                          controller:
                              FixedExtentScrollController(initialItem: 00),
                          // useMagnifier: true,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              12,
                              (int index) {
                                return _TimeText(text: index.toString());
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      kText(
                          text: ':',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      SizedBox(width: 10.0),
                      Container(
                        width: 50.0,
                        height: 100.0,
                        child: ListWheelScrollView.useDelegate(
                          diameterRatio: 1.5,
                          onSelectedItemChanged: (min) {
                            _minuteValue = min != null ? min : 0;
                            print(min);
                          },
                          controller:
                              FixedExtentScrollController(initialItem: 00),
                          squeeze: 0.5,
                          itemExtent: 25.0,
                          // overAndUnderCenterOpacity: 0.5,
                          clipBehavior: Clip.antiAlias,
                          // useMagnifier: true,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              60,
                              (int index) {
                                return _TimeText(text: index.toString());
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      kText(
                          text: ':',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      SizedBox(width: 10.0),
                      Container(
                        width: 50.0,
                        height: 100.0,
                        child: ListWheelScrollView.useDelegate(
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List<Widget>.generate(
                              60,
                              (int index) {
                                return _TimeText(text: index.toString());
                              },
                            ),
                          ),
                          diameterRatio: 1.5,
                          onSelectedItemChanged: (sec) {
                            _secondValue = sec != null ? sec : 0;
                            print(sec);
                          },
                          controller:
                              FixedExtentScrollController(initialItem: 00),
                          squeeze: 0.5,
                          itemExtent: 25.0,
                          // useMagnifier: true,
                        ),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(
                        Icons.notifications,
                      ),
                      onPressed: () {}),
                  IconButton(
                    iconSize: 50,
                    color: Colors.white,
                    icon: Icon(
                      Icons.play_arrow,
                    ),
                    onPressed: () {
                      _hrsValue = _hrsValue != null ? _hrsValue : 0;
                      _minuteValue = _minuteValue != null ? _minuteValue : 0;
                      _secondValue = _secondValue != null ? _secondValue : 0;
                      int time = (_hrsValue * 60 * 60) +
                          (_minuteValue * 60) +
                          _secondValue;
                      print(time);
                    },
                  ),
                  IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(
                        Icons.refresh,
                      ),
                      onPressed: () {}),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class TimerPainter extends CustomPainter {
  var datetime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    // print(datetime);
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    Paint fillBrush = Paint()..color = Color(0xFF444974);
    Paint outlinedBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 20;
    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlinedBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (var i = 0; i < 360; i += 10) {
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

class _TimeText extends StatelessWidget {
  final String text;

  _TimeText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.padLeft(2, '0'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      ),
    );
  }
}
