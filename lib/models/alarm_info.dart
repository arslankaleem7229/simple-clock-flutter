import 'package:flutter/material.dart';

class AlarmInfo {
  DateTime alarmDateTime;
  String title;
  bool isActive;
  List<Color> gradientColor;
  AlarmInfo(this.alarmDateTime,
      {this.title, this.isActive, this.gradientColor});
}
