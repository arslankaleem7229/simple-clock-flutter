import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';

class TimerModel extends StatefulWidget {
  final double size;
  TimerModel({@required this.size});
  @override
  _TimerModelState createState() => _TimerModelState();
}

class _TimerModelState extends State<TimerModel> with TickerProviderStateMixin {
  AnimationController animationController;
  int hrsValue, minValue, secValue, totalTimeinSeconds;
  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    setTimerDuration(timerseconds: 00);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  setTimerDuration(
      {int timerseconds = 0, int timerminutes = 0, int timerhrs = 0}) {
    return animationController = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: timerseconds, minutes: timerminutes, hours: timerhrs));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      margin: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: FractionalOffset.center,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget child) {
                          return CustomPaint(
                            painter: TimerPainter(
                                animation: animationController,
                                backgroundColor: Colors.white,
                                color: Theme.of(context).accentColor),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Count Down",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (_, Widget child) {
                              return Text(
                                timerString,
                                style: Theme.of(context).textTheme.headline2,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                    setState(() {
                      hrsValue = (hrs != null || hrs != 0) ? hrs : 0;
                    });
                  },
                  controller: FixedExtentScrollController(initialItem: 00),
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
                    minValue = (min != null || min != 0) ? min : 0;
                  },
                  controller: FixedExtentScrollController(initialItem: 00),
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
                    secValue = (sec != null || sec != 0) ? sec : 0;
                  },
                  controller: FixedExtentScrollController(initialItem: 00),
                  squeeze: 0.5,
                  itemExtent: 25.0,
                  // useMagnifier: true,
                ),
              ),
              SizedBox(width: 10.0),
            ],
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: Icon(Icons.add_circle_outline_sharp),
                  onPressed: () {
                    hrsValue = hrsValue == null ? 0 : hrsValue;
                    minValue = minValue == null ? 0 : minValue;
                    secValue = secValue == null ? 0 : secValue;
                    setState(() {
                      setTimerDuration(
                          timerseconds: secValue,
                          timerhrs: hrsValue,
                          timerminutes: minValue);
                    });
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: AnimatedBuilder(
                      animation: animationController,
                      builder: (_, Widget child) {
                        return Icon(animationController.isAnimating
                            ? Icons.pause
                            : Icons.play_arrow);
                      }),
                  onPressed: () {
                    if (animationController.isAnimating) {
                      setState(() {
                        animationController.stop();
                      });
                    } else {
                      setState(() {
                        animationController.reverse(
                            from: animationController.value == 0.0
                                ? 1.0
                                : animationController.value);
                      });
                    }
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      if (animationController.isAnimating) {
                        animationController.stop();
                      }
                      setTimerDuration(timerseconds: 0);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
