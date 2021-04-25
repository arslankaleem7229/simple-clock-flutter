import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/constants/floatingActionButtonWidget.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/constants/timePicker.dart';
import 'package:simple_clock_flutter/constants/timerPainer.dart';

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
    return '''${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}''';
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
        seconds: timerseconds,
        minutes: timerminutes,
        hours: timerhrs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      margin: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
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
                              color: Theme.of(context).accentColor,
                            ),
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
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (_, Widget child) {
                              return Text(
                                timerString,
                                style: Theme.of(context).textTheme.headline3,
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
          kText(text: "Set Timer", fontSize: 20),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(colors: GradientColors.sky),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildtimePicker(
                    listWheelChildDelegate:
                        listWheelChildLoopingListDelegate(value: 12),
                    buildContext: context,
                    selected: (hrs) {
                      setState(() {
                        hrsValue = (hrs != null || hrs != 0) ? hrs : 0;
                      });
                    },
                  ),
                  colonText(),
                  buildtimePicker(
                    buildContext: context,
                    listWheelChildDelegate:
                        listWheelChildLoopingListDelegate(value: 60),
                    selected: (min) {
                      minValue = (min != null || min != 0) ? min : 0;
                    },
                  ),
                  colonText(),
                  buildtimePicker(
                    buildContext: context,
                    listWheelChildDelegate:
                        listWheelChildLoopingListDelegate(value: 60),
                    selected: (sec) {
                      secValue = (sec != null || sec != 0) ? sec : 0;
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(35),
              ),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  expandedFloatingActionButton(
                    backgroundColor: Color(0xFF444974),
                    elevation: 0,
                    widget: Icon(Icons.add_circle_outline_sharp, size: 35),
                    onClicked: () {
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
                  expandedFloatingActionButton(
                    backgroundColor: Color(0xFF444974),
                    elevation: 0,
                    widget: AnimatedBuilder(
                        animation: animationController,
                        builder: (_, Widget child) {
                          return Icon(
                            animationController.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 40,
                          );
                        }),
                    onClicked: () {
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
                  expandedFloatingActionButton(
                    backgroundColor: Color(0xFF444974),
                    elevation: 0,
                    widget: Icon(Icons.refresh, size: 35),
                    onClicked: () {
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
          ),
        ],
      ),
    );
  }
}
