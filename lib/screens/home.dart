import 'dart:async';

import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:dotted_border/dotted_border.dart';
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
                      : buildAlarmScreen(
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

  Container buildAlarmScreen({
    @required DateTime dateTime,
    @required String formattedTime,
    @required String formattedDate,
    @required String timeZone,
    @required String timeZoneSign,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 20, left: 5),
              child: kText(
                  text: "Alarm", fontWeight: FontWeight.w700, fontSize: 30)),
          Expanded(
            child: ListView(
                children: alarms.map<Widget>((alarm) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.only(bottom: 22),
                // height: MediaQuery.of(context).size.height * 0.15,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: alarm.gradientColor,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: alarm.gradientColor.last.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(4, 4),
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.label,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            kText(
                                text: alarm.description,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)
                          ],
                        ),
                        GestureDetector(
                          child: CustomSwitchButton(
                            backgroundColor: Colors.white,
                            unCheckedColor: alarm.gradientColor.last,
                            animationDuration: Duration(milliseconds: 300),
                            checkedColor: alarm.gradientColor.last,
                            checked: alarm.isActive,
                          ),
                          onTap: () {
                            setState(() {
                              alarm.isActive = !alarm.isActive;
                            });
                          },
                        ),
                      ],
                    ),
                    kText(text: "Mon - Fri", fontSize: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        kText(
                            text: formattedTime,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).followedBy([
              DottedBorder(
                strokeWidth: 3,
                borderType: BorderType.RRect,
                color: CustomColors.clockOutline,
                radius: Radius.circular(24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: CustomColors.clockBG,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {},
                    child: Column(
                      children: [
                        Image.asset('assets/add_alarm.png', scale: 1.2),
                        SizedBox(height: 10),
                        kText(text: "Add Alarm", fontSize: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ]).toList()),
          ),
        ],
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
