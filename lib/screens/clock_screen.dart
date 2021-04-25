import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_clock_flutter/constants/text_widget.dart';
import 'package:simple_clock_flutter/models/clock_view.dart';

double width;
double height;

class ClockScreen extends StatefulWidget {
  final DateTime dateTime;
  final String formattedTime;
  final String formattedDate;
  final String timeZone;
  final String timeZoneSign;
  ClockScreen({
    @required this.dateTime,
    @required this.formattedTime,
    @required this.formattedDate,
    @required this.timeZone,
    @required this.timeZoneSign,
  });

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: kText(
                  text: "Clock", fontWeight: FontWeight.w700, fontSize: 30)),
          Expanded(
            flex: 3,
            child: Align(
              child: DigitalClockWidget(),
              alignment: Alignment.centerLeft,
            ),
          ),
          kText(
              text: widget.formattedDate,
              fontSize: 20,
              fontWeight: FontWeight.w300),
          Expanded(
            flex: 6,
            child: Align(
              child: ClockModel(size: width / 1.5),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            flex: 4,
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
                              text:
                                  "UTC: ${widget.timeZoneSign}${widget.timeZone}",
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
}

class DigitalClockWidget extends StatefulWidget {
  @override
  _DigitalClockWidgetState createState() => _DigitalClockWidgetState();
}

class _DigitalClockWidgetState extends State<DigitalClockWidget> {
  Timer timer;

  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  @override
  void initState() {
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //condition to check weather the minute is increased or not

      if (DateTime.now().add(Duration(seconds: -1)).minute !=
          DateTime.now().minute) {
        setState(() {
          formattedTime = DateFormat('HH:mm').format(DateTime.now());
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kText(text: formattedTime, fontSize: 64);
  }
}
