import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/enums.dart';
import 'package:simple_clock_flutter/models/clock_view.dart';
import 'package:intl/intl.dart';
import 'package:simple_clock_flutter/models/data.dart';
import 'package:simple_clock_flutter/models/menu_info.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/screens/alarm_screen.dart';

double width;

double height;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer timer;
  @override
  void initState() {
    // timer = Timer.periodic(Duration(minutes: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

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
                      ? buildClockScreen(
                          dateTime: dateTime,
                          formattedDate: formattedDate,
                          formattedTime: formattedTime,
                          timeZone: timeZone,
                          timeZoneSign: timeZoneSign,
                        )
                      : AlarmScreen(
                          dateTime: dateTime,
                          formattedDate: formattedDate,
                          formattedTime: formattedTime,
                          timeZone: timeZone,
                          timeZoneSign: timeZoneSign,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildClockScreen({
    @required DateTime dateTime,
    @required String formattedTime,
    @required String formattedDate,
    @required String timeZone,
    @required String timeZoneSign,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: kText(
                  text: "Clock", fontWeight: FontWeight.w700, fontSize: 30)),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kText(text: formattedTime, fontSize: 64),
                kText(
                    text: formattedDate,
                    fontSize: 20,
                    fontWeight: FontWeight.w300)
              ],
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Align(
              child: ClockModel(size: width / 1.5),
              alignment: Alignment.center,
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kText(
                    text: "Timezone",
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.language, color: Colors.white, size: 30),
                      SizedBox(width: 15),
                      Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: kText(
                              text: "UTC: $timeZoneSign$timeZone",
                              fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
