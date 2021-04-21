import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/constants/theme_data.dart';
import 'package:simple_clock_flutter/main.dart';
import 'package:simple_clock_flutter/models/alarm_helper.dart';
import 'package:simple_clock_flutter/models/alarm_info.dart';
import 'package:simple_clock_flutter/models/data.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('-------Database Initialized-------');
      _alarms = _alarmHelper.getAlarms();
    });
    super.initState();
  }

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
            child: FutureBuilder(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView(
                      children: snapshot.data.map<Widget>((alarm) {
                    var _isPending;
                    if (alarm.isPending == 0)
                      _isPending = false;
                    else
                      _isPending = true;

                    var alarmTime =
                        DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                    var gradientColor = GradientTemplate
                        .gradientTemplate[alarm.gradientColorIndex].colors;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.only(bottom: 22),
                      // height: MediaQuery.of(context).size.height * 0.15,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.4),
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
                                  unCheckedColor: GradientColors.sky.last,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  checkedColor: GradientColors.sky.last,
                                  checked: _isPending,
                                ),
                                onTap: () {
                                  setState(() {
                                    alarm.isPending = !alarm.isPending;
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
                      dashPattern: [5, 4],
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: CustomColors.clockBG,
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              _alarmTimeString =
                                  DateFormat('HH:mm').format(DateTime.now());

                              showModalBottomSheet(
                                useRootNavigator: true,
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                              ),
                                              onPressed: () async {
                                                var selectedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (selectedTime != null) {
                                                  final now = DateTime.now();
                                                  var selectedDateTime =
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          selectedTime.hour,
                                                          selectedTime.minute);
                                                  _alarmTime = selectedDateTime;
                                                  setModalState(() {
                                                    _alarmTimeString =
                                                        DateFormat('HH:mm')
                                                            .format(
                                                                selectedDateTime);
                                                  });
                                                }
                                              },
                                              child: Text(
                                                _alarmTimeString,
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text('Repeat'),
                                              trailing:
                                                  Icon(Icons.arrow_forward_ios),
                                            ),
                                            ListTile(
                                              title: Text('Sound'),
                                              trailing:
                                                  Icon(Icons.arrow_forward_ios),
                                            ),
                                            ListTile(
                                              title: Text('Title'),
                                              trailing:
                                                  Icon(Icons.arrow_forward_ios),
                                            ),
                                            FloatingActionButton.extended(
                                              onPressed: () {
                                                DateTime scheduleAlarmDateTime;
                                                if (_alarmTime
                                                    .isAfter(DateTime.now())) {
                                                  scheduleAlarmDateTime =
                                                      _alarmTime;
                                                } else {
                                                  scheduleAlarmDateTime =
                                                      _alarmTime.add(
                                                          Duration(days: 1));
                                                }
                                                var alarmInfo = AlarmInfo(
                                                  alarmDateTime:
                                                      scheduleAlarmDateTime,
                                                  gradientColorIndex:
                                                      alarms.length,
                                                  title: 'alarm',
                                                  isPending: true,
                                                );
                                                _alarmHelper
                                                    .insertAlarm(alarmInfo);
                                              },
                                              icon: Icon(Icons.alarm),
                                              label: Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset('assets/add_alarm.png', scale: 1.2),
                                SizedBox(height: 10),
                                kText(text: "Add Alarm", fontSize: 14),
                              ],
                            )),
                      ),
                    ),
                  ]).toList());
                else
                  return Center(child: kText(text: 'Loading...', fontSize: 24));
              },
            ),
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
