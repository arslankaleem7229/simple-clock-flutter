import 'package:flutter/material.dart';
import 'package:flutter/stop_watch_timer.dart';
import 'package:simple_clock_flutter/constants/floatingActionButtonWidget.dart';

class StopWatchView extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => StopWatchView(),
      ),
    );
  }

  @override
  _StateStopWatchView createState() => _StateStopWatchView();
}

class _StateStopWatchView extends State<StopWatchView> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Display stop watch time
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: _stopWatchTimer.rawTime.valueWrapper?.value,
          builder: (context, snap) {
            final value = snap.data;
            final displayTime =
                StopWatchTimer.getDisplayTime(value, hours: _isHours);
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                child: Text(
                  displayTime,
                  style: const TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.all(8),
          child: StreamBuilder<List<StopWatchRecord>>(
            stream: _stopWatchTimer.records,
            initialData: _stopWatchTimer.records.valueWrapper?.value,
            builder: (context, snap) {
              final value = snap.data;
              if (value.isEmpty) {
                return Container();
              }
              Future.delayed(const Duration(milliseconds: 100), () {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut);
              });
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final data = value[index];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${index + 1} ${data.displayTime}',
                          style: const TextStyle(
                              fontSize: 17,
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        height: 1,
                      )
                    ],
                  );
                },
                itemCount: value.length,
              );
            },
          ),
        ),

        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  expandedFloatingActionButton(
                    widget: Text("Start"),
                    backgroundColor: Colors.lightBlue,
                    onClicked: () async {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    },
                  ),
                  expandedFloatingActionButton(
                    widget: Text("Stop"),
                    backgroundColor: Colors.green,
                    onClicked: () async {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  expandedFloatingActionButton(
                    widget: Text("Reset"),
                    backgroundColor: Colors.red,
                    onClicked: () async {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    },
                  ),
                  expandedFloatingActionButton(
                    widget: Text("Lap"),
                    backgroundColor: Colors.deepPurpleAccent,
                    onClicked: () async {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                    },
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
