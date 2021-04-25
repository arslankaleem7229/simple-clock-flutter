import 'package:simple_clock_flutter/enums.dart';
import 'package:simple_clock_flutter/models/alarm_info.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/icons/clock_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarm', imageSource: 'assets/icons/alarm_icon.png'),
  MenuInfo(MenuType.timer,
      title: 'Timer', imageSource: 'assets/icons/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'Stopwatch', imageSource: 'assets/icons/stopwatch_icon.png'),
];
List<AlarmInfo> alarms = [
  AlarmInfo(
      alarmDateTime: DateTime.now().add(Duration(hours: 1)),
      title: "Office",
      isPending: 1,
      gradientColorIndex: 1),
  AlarmInfo(
      alarmDateTime: DateTime.now().add(Duration(hours: 5)),
      title: "Sports",
      isPending: 0,
      gradientColorIndex: 2),
];
