import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/enums.dart';
import 'package:intl/intl.dart';
import 'package:simple_clock_flutter/models/data.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/screens/alarm_screen.dart';
import 'package:simple_clock_flutter/screens/clock_screen.dart';
import 'package:simple_clock_flutter/screens/stopwatch_screen.dart';
import 'package:simple_clock_flutter/screens/timer_screen.dart';

double width;

double height;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    DateTime dateTime = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    String formattedDate = DateFormat('EEE, d MMM').format(dateTime);
    String timeZone =
        dateTime.timeZoneOffset.toString().split('.').first.substring(0, 4);
    String timeZoneSign = '';
    if (!timeZone.startsWith('-')) timeZoneSign = '+ ';
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      body: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems
                  .map((currentMenuInfo) =>
                      buildMenuButton(currentMenuInfo: currentMenuInfo))
                  .toList(),
            ),
            VerticalDivider(color: Colors.white54, width: 1),
            Expanded(
              child: Consumer<MenuInfo>(
                builder: (context, value, child) {
                  return value.menuType == MenuType.clock
                      ? ClockScreen(
                          dateTime: dateTime,
                          formattedTime: formattedTime,
                          formattedDate: formattedDate,
                          timeZone: timeZone,
                          timeZoneSign: timeZoneSign)
                      : value.menuType == MenuType.alarm
                          ? AlarmScreen()
                          : value.menuType == MenuType.timer
                              ? TimerScreen()
                              : StopwatchScreen();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton({@required MenuInfo currentMenuInfo}) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)))),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            ),
            backgroundColor: currentMenuInfo.menuType == value.menuType
                ? MaterialStateProperty.all(CustomColors.menuBackgroundColor)
                : MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            MenuInfo menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenuInfo(currentMenuInfo);
          },
          child: Column(
            children: [
              Image.asset(currentMenuInfo.imageSource,
                  scale: currentMenuInfo.title == 'Alarm' ||
                          currentMenuInfo.title == 'Timer' ||
                          currentMenuInfo.title == 'Clock'
                      ? 1.3
                      : 1.5),
              SizedBox(height: 16),
              kText(
                  text: currentMenuInfo.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)
            ],
          ),
        );
      },
    );
  }
}
