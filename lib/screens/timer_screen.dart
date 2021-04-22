import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/models/timer_view.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return TimerModel(size: 250);
  }
}
