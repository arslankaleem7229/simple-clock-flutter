import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/main.dart';
import 'package:simple_clock_flutter/models/alarm_info.dart';
import 'package:simple_clock_flutter/models/data.dart';

class AlarmScreen extends StatefulWidget {
  AlarmScreen({
    @required DateTime dateTime,
    @required String formattedTime,
    @required String formattedDate,
    @required String timeZone,
    @required String timeZoneSign,
  });

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
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
                                text: alarm.title,
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
                            text: alarm.alarmDateTime
                                .toString()
                                .substring(11, 16),
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
                    onPressed: () {
                      scheduleAlarm(
                          alarmInfo: alarms.first,
                          scheduledNotificationDateTime:
                              DateTime.now().add(Duration(seconds: 5)));
                    },
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

  void scheduleAlarm(
      {DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'appicon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('appicon'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Office',
      alarmInfo.title,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }
}
