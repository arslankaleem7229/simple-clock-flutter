import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/enums.dart';
import 'package:simple_clock_flutter/models/alarm_info.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/clock_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarm', imageSource: 'assets/alarm_icon.png'),
  MenuInfo(MenuType.timer,
      title: 'Timer', imageSource: 'assets/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'Stopwatch', imageSource: 'assets/stopwatch_icon.png'),
];
List<AlarmInfo> alarms = [
  AlarmInfo(DateTime.now().add(Duration(hours: 1)),
      description: "Office", isActive: true, gradientColor: GradientColors.sky),
  AlarmInfo(DateTime.now().add(Duration(hours: 5)),
      description: "Sports",
      isActive: false,
      gradientColor: GradientColors.fire),
];
