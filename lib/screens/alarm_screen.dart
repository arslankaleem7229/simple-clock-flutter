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

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  TextEditingController _controller = TextEditingController();
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;
  List<AlarmInfo> _currentAlarms;
  String _title = '';
  String _enableStatus;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
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
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                      children: snapshot.data.map<Widget>((AlarmInfo alarm) {
                    bool _pending;
                    _pending = alarm.isPending == 1 ? true : false;

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
                                  checked: _pending,
                                ),
                                onTap: () => _pending == true
                                    ? updateAlarm(alarm.id, 0)
                                    : updateAlarm(alarm.id, 1),
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
                              IconButton(
                                color: Colors.white,
                                onPressed: () => deleteAlarm(alarm.id),
                                icon: Icon(Icons.delete),
                                iconSize: 24,
                                padding: EdgeInsets.only(left: 25),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).followedBy([
                    if (_currentAlarms.length < 5)
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
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
                                          child: ListView(
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
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                        DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            selectedTime.hour,
                                                            selectedTime
                                                                .minute);
                                                    _alarmTime =
                                                        selectedDateTime;
                                                    setModalState(
                                                      () {
                                                        _alarmTimeString =
                                                            DateFormat('HH:mm')
                                                                .format(
                                                                    selectedDateTime);
                                                      },
                                                    );
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
                                                // trailing: Icon(
                                                //     Icons.arrow_forward_ios),
                                                trailing:
                                                    DropdownButton<String>(
                                                  value: "Enable",
                                                  icon: const Icon(
                                                      Icons.arrow_downward),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.deepPurple),
                                                  underline: Container(
                                                    height: 2,
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      _enableStatus = newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Enable',
                                                    'Disable'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('Sound'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 20),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    _title = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(16.0),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.blueAccent,
                                                        )),
                                                    labelText: "Title",
                                                    labelStyle: TextStyle(
                                                      color: Colors.lightBlue,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  controller: _controller,
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  cursorColor: Colors.redAccent,
                                                  cursorWidth: 1.5,
                                                  maxLength: 10,
                                                ),
                                              ),
                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  int status;
                                                  if (equalsIgnoreCase(
                                                      _enableStatus,
                                                      "Enable")) {
                                                    status = 1;
                                                  } else if (equalsIgnoreCase(
                                                      _enableStatus,
                                                      "Disable")) {
                                                    status = 0;
                                                  } else {
                                                    status = 1;
                                                  }
                                                  _controller.clear();
                                                  onSaveAlarm(
                                                      title: _title,
                                                      status: status);
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
                                  Image.asset('assets/icons/add_alarm.png',
                                      scale: 1.2),
                                  SizedBox(height: 10),
                                  kText(text: "Add Alarm", fontSize: 14),
                                ],
                              )),
                        ),
                      )
                    else
                      Center(
                          child: Text(
                        'Only 5 alarms allowed!',
                        style: TextStyle(color: Colors.white),
                      )),
                  ]).toList());
                } else
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

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    loadAlarms();
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  void onSaveAlarm({String title, int status}) {
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms.length,
      title: title,
      isPending: status,
    );
    _alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(
        scheduledNotificationDateTime: scheduleAlarmDateTime,
        alarmInfo: alarmInfo);
    Navigator.pop(context);
    loadAlarms();
  }

  void updateAlarm(int id, int pending) {
    _alarmHelper.update(id, pending);
    loadAlarms();
  }
}
