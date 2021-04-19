import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/models/clock_view.dart';
import 'package:intl/intl.dart';
import 'package:simple_clock_flutter/models/menu_button.dart';
import 'package:simple_clock_flutter/models/text_widget.dart';

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
    timer = Timer.periodic(Duration(minutes: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('=========================Fuck=========================');
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var dateTime = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(dateTime);
    var formattedDate = DateFormat('EEE, d MMM').format(dateTime);
    var timeZone =
        dateTime.timeZoneOffset.toString().split('.').first.substring(0, 4);
    var timeZoneSign = '';
    if (!timeZone.startsWith('-')) timeZoneSign = '+ ';
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      body: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMenuButton(image: 'assets/clock_icon.png', label: 'Clock'),
                buildMenuButton(image: 'assets/alarm_icon.png', label: 'Alarm'),
                buildMenuButton(image: 'assets/timer_icon.png', label: 'Timer'),
                buildMenuButton(
                    image: 'assets/stopwatch_icon.png', label: 'Stopwatch'),
              ],
            ),
            VerticalDivider(color: Colors.white54, width: 1),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: kText(
                            text: "Clock",
                            fontWeight: FontWeight.w700,
                            fontSize: 24)),
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
                                Icon(Icons.language,
                                    color: Colors.white, size: 30),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
