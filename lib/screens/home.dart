import 'package:flutter/material.dart';
import 'package:simple_clock_flutter/screens/clock_view.dart';
import 'package:intl/intl.dart';

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
    var dateTime = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(dateTime);
    var formattedDate = DateFormat('EEE, d MMM').format(dateTime);
    var timeZone =
        dateTime.timeZoneOffset.toString().split('.').first.substring(0, 4);
    var timeZoneSign = '';
    if (timeZone.startsWith('-')) {
      timeZoneSign = '-';
    } else {
      timeZoneSign = '+';
    }
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      body: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMenuButton(path: 'assets/clock_icon.png', text: 'Clock'),
                buildMenuButton(path: 'assets/alarm_icon.png', text: 'Alarm'),
                buildMenuButton(path: 'assets/timer_icon.png', text: 'Timer'),
                buildMenuButton(
                    path: 'assets/stopwatch_icon.png', text: 'Stopwatch'),
              ],
            ),
            VerticalDivider(color: Colors.white54, width: 1),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Clock",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 35),
                    Text(
                      "$formattedTime",
                      style: TextStyle(color: Colors.white, fontSize: 64),
                    ),
                    Text(
                      "$formattedDate",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 15),
                    ClockView(),
                    SizedBox(height: 15),
                    Text(
                      "Timezone",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.language, color: Colors.white, size: 30),
                          SizedBox(width: 15),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text(
                              "UTC: $timeZoneSign$timeZone",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
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

  Padding buildMenuButton({@required String path, @required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Column(
          children: [
            Image(image: AssetImage(path), height: 50, width: 50),
            SizedBox(height: 16),
            Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ],
        ),
        onPressed: () => print(text),
      ),
    );
  }
}
